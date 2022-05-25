# Voltage divider - resistor values combinations (E24)

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

print("Calculate E24 resistor values combinations for voltage divider")
print("")
print("Vin")
print(" ┬ ")
print("┌┴┐")
print("│ │ R1")
print("└┬┘")
print(" ├────> Vout")
print("┌┴┐")
print("│ │ R2")
print("└┬┘")
print(" ┴ GND")
print("")
print("Vout = Vin * R2/(R1+R2)")
print("I = Vin / (R1+R2)")
print("")

def CalcVout(Vin, R1, R2):
        return Vin*R2/(R1+R2)

Vin = float(input("Enter Vin (in V): "))
Vout_target = float(input("Enter Target Vout (in V): "))
Tol = float(input("Enter Vout tolerance (in V): "))

result = []
for i in mult_R1_max:
        for j in mult_R2_max:
                R1_list = [R1 * i for R1 in resistor_list]
                R2_list = [R2 * j for R2 in resistor_list]
                for R1 in R1_list:
                        for R2 in R2_list:
                                Vout = CalcVout(Vin, R1, R2)
                                if abs(Vout-Vout_target) <= Tol:
                                        error_percent = (Vout-Vout_target)/Vout_target*100
                                        result.append([R1,R2,round(Vout,3),round(error_percent,3)])

result_sorted = sorted(result, key=lambda result: abs(result[3]))

# print("")
# print("Result (sorted with ascending %_error):")
# print("[R1, R2, Vout, %_error]")
# for i in result_sorted:
#         # print(i[0:][0:])
#         print(i)

print("")
print("Result (ascending Error %):")
# pt = try_import("prettytable")
result_pt = pt.PrettyTable()
result_pt.field_names = ["R1", "R2", "Vout", "Error %"]
result_pt.align = "r"
result_pt.add_rows(result_sorted)
print(result_pt)
