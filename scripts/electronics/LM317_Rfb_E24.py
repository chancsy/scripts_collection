# LM317 - feedback resistor values combinations (E24)

def try_import(module_name):
    # Try to import module, exit script with installation information if module not found
    import sys
    import importlib
    try:
        import_as = importlib.import_module(module_name, package=None)
    except ImportError:
        msg = "You need "'"%s"'", install it from https://pypi.org/project/ or run "'"pip install %s"'"" % (module_name, module_name)
        sys.exit(msg)
    return import_as

from constants import *
mult_R1_max = [1,10,100,1000]
mult_R2_max = [1,10,100,1000]
resistor_list = E24_list

pt = try_import("prettytable")

print("LM317 - feedback resistor values combinations (E24)")
print("")
print("        ┌───────┐")
print("Vin >───┤  Reg  ├────┬───> Vout")
print("        └───┬───┘   ┌┴┐")
print("            │Vref   │ │ R1")
print("            │       └┬┘")
print("            └────────┤")
print("                    ┌┴┐")
print("                    │ │ R2")
print("                    └┬┘")
print("                     ┴ GND")
print("")
print("Vout = Vref * (1+R2/R1) + (Iadj*R2)")
print("")

def CalcVout(Vref, Iadj, R1, R2):
        return Vref*(1+R2/R1)+(Iadj/1000000)*R2

Vref = float(input("Enter regulator Vref (V, 1.25V typical): "))
Iadj = float(input("Enter regulator Iadj (uA, 50uA typical, enter ""0"" to ignore): "))
Vout_target = float(input("Enter Target Vout (V): "))
Tol = float(input("Enter Vout tolerance (V): "))

result = []
for i in mult_R1_max:
        for j in mult_R2_max:
                R1_list = [R1 * i for R1 in resistor_list]
                R2_list = [R2 * j for R2 in resistor_list]
                for R1 in R1_list:
                        for R2 in R2_list:
                                Vout = CalcVout(Vref, Iadj, R1, R2)
                                if abs(Vout-Vout_target) <= Tol:
                                        diff_percent = (Vout-Vout_target)/Vout_target*100
                                        result.append([R1,R2,round(Vout,3),round(diff_percent,3)])

result_sorted = sorted(result, key=lambda result: abs(result[3]))

# print("")
# print("[R1, R2, Vout, %_diff]")
# for i in result_sorted:
#         print(i[0:][0:])
                                      
print("")
print("Result (ascending Error %):")
# pt = try_import("prettytable")
result_pt = pt.PrettyTable()
result_pt.field_names = ["R1", "R2", "Vout", "% Error"]
result_pt.align = "r"
result_pt.add_rows(result_sorted)
print(result_pt)
