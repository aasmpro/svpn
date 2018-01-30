import tkinter as tk
from tkinter import ttk, messagebox
import subprocess
import pathlib

prg = subprocess.run('command -v pkexec gksudo'.split(), stdout=subprocess.PIPE)
prg = prg.stdout.decode('utf-8').split('\n')[0].split('/')[-1] or None


class Application(tk.Frame):
    def __init__(self, master=None):
        super().__init__(master)
        self.master.title("svpn")
        self.con = tk.BooleanVar(value=True)
        self.create_widgets()
        self.pack()

    def create_widgets(self):
        fr1 = tk.Frame(self)
        fr1.pack(fill='x')

        self.server_l = tk.Label(fr1, text='server :')
        self.server_l.pack(side="left", padx=5, pady=5)

        self.server = tk.StringVar()
        self.server_c = ttk.Combobox(fr1, state="readonly", values=['us7', 'uk', 'nl', 'ca', 'fr', 'de', 'ro'],
                                     textvariable=self.server)
        self.server_c.current(0)
        self.server_c.pack(side='right', padx=5, pady=5)

        fr2 = tk.Frame(self)
        fr2.pack(fill='x')

        self.username_l = tk.Label(fr2, text='username :')
        self.username_l.pack(side="left", padx=5, pady=5)

        self.username = tk.Entry(fr2)
        self.username.pack(side='right', fill='x', padx=5, pady=5)

        fr3 = tk.Frame(self)
        fr3.pack(fill='x')

        self.password_l = tk.Label(fr3, text='password :')
        self.password_l.pack(side="left", padx=5, pady=5)

        self.password = tk.Entry(fr3, show='*')
        self.password.pack(side='right', fill='x', padx=5, pady=5)

        fr4 = tk.Frame(self)
        fr4.pack(fill='x')

        self.save_login = tk.IntVar(value=0)
        self.save_c = ttk.Checkbutton(fr4, text='save login', variable=self.save_login)
        self.save_c.pack(side='left')

        self.con_dis = tk.Button(self, text='Connect', command=self.connect)
        self.con_dis.pack(side='bottom')

    def connect(self):
        if prg:
            if self.con.get():
                if self.username.get() and self.password.get():
                    prs = [prg, 'svpn', '-c', '-s', self.server.get(), '-u',
                           self.username.get(), '-p', self.password.get()]
                    result = subprocess.Popen(prs, stdout=subprocess.PIPE).communicate()

                    if str(result).__contains__('Server certificate verify failed'):
                        messagebox.showerror('Login', 'Wrong username or password\nor you are already logged in.')
                    else:
                        self.con.set(False)
                        self.con_dis['text'] = 'Disconnect'
                else:
                    messagebox.showerror('Login', 'Please enter username and password.')
            else:
                subprocess.run([prg, 'svpn', '-d'])
                self.con.set(True)
                self.con_dis['text'] = 'Connect'

        else:
            messagebox.showerror('Error', 'There is no graphical authentication program.\neg. pkexec or gksudo')


def main():
    def on_closing():
        if prg and not app.con.get():
            subprocess.run([prg, 'svpn', '-d'])
        if app.save_login.get():
            with open("{}/.svpn.conf".format(str(pathlib.Path.home())), "w+") as conf:
                conf.write(app.username.get())
                conf.write('\n')
                conf.write(app.password.get())
        else:
            open("{}/.svpn.conf".format(str(pathlib.Path.home())), "w+")

        root.destroy()

    def load_data(app):
        try:
            data = open("{}/.svpn.conf".format(str(pathlib.Path.home())), "r").read().split('\n')
            app.username.insert(0, data[0] if data[0] else '')
            app.password.insert(0, data[1] if data[1] else '')
            app.save_login.set(1)

        except FileNotFoundError:
            open("{}/.svpn.conf".format(str(pathlib.Path.home())), "w+")

    root = tk.Tk()
    root.protocol("WM_DELETE_WINDOW", on_closing)
    root.resizable(False, False)
    app = Application(master=root)
    load_data(app)
    app.mainloop()


if __name__ == "__main__":
    main()
