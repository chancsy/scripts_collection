# Calculate E48 resistor values combinations for voltage divider with current limit

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

pt = try_import("prettytable")

print("Calculate E48 resistor values combinations for voltage divider with current limit")
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

E24_list=[100, 110, 120, 130, 150, 160, 180, 200, 220, 240,
          270, 300, 330, 360, 390, 430, 470, 510, 560, 620,
          680, 750, 820, 910]
E48_list=[100, 105, 110, 115, 121, 127, 133, 140, 147, 154,
          162, 169, 178, 187, 196, 205, 215, 226, 237, 249,
          261, 274, 287, 301, 316, 332, 348, 365, 383, 402,
          422, 442, 464, 487, 511, 536, 562, 590, 619, 649,
          681, 715, 750, 787, 825, 866, 909, 953]
E96_list=[100, 102, 105, 107, 110, 113, 115, 118, 121, 124,
          127, 130, 133, 137, 140, 143, 147, 150, 154, 158,
          162, 165, 169, 174, 178, 182, 187, 191, 196, 200,
          205, 210, 216, 221, 226, 232, 237, 243, 249, 255,
          261, 267, 274, 280, 287, 294, 301, 309, 316, 324,
          332, 340, 348, 357, 365, 374, 383, 392, 402, 412,
          422, 432, 442, 453, 464, 475, 487, 499, 511, 523,
          536, 549, 562, 576, 590, 604, 619, 634, 649, 665,
          681, 698, 715, 732, 750, 768, 787, 806, 825, 845,
          866, 887, 909, 931, 953, 976]
mult_R1_max = [1,10,100,1000]
mult_R2_max = [1,10,100,1000]

def CalcVout(Vin, R1, R2):
        return Vin*R2/(R1+R2)

Vin = float(input("Enter Vin (in V): "))
Vout_target = float(input("Enter Target Vout (in V): "))
Tol = float(input("Enter Vout tolerance (in V): "))
Imin = float(input("Enter Target Imin (in A): "))
Imax = float(input("Enter Target Imax (in A): "))

result = []
for i in mult_R1_max:
        for j in mult_R2_max:
                R1_list = [R1 * i for R1 in E48_list]
                R2_list = [R2 * j for R2 in E48_list]
                for R1 in R1_list:
                        for R2 in R2_list:
                                Vout = CalcVout(Vin, R1, R2)
                                if abs(Vout-Vout_target) <= Tol:
                                        Inetwork = Vin/(R1+R2)
                                        if (Inetwork>=Imin) and (Inetwork<=Imax):
                                                diff_percent = (Vout-Vout_target)/Vout_target*100
                                                result.append([R1,R2,round(Vout,3),round(diff_percent,3),Inetwork])
                                                # print("R1="+str(R1),"R2="+str(R2),"Vout="+str(Vout),"I="+str(Inetwork))

result_sorted = sorted(result, key=lambda result: abs(result[3]))

# print("")
# print("Result (sorted with ascending %_error)")
# print("[R1, R2, Vout, %_error], I")
# for i in result_sorted:
#         # print(i[0:][0:])
#         print(i)

print("")
print("Result (ascending Error %):")
# pt = try_import("prettytable")
result_pt = pt.PrettyTable()
result_pt.field_names = ["R1", "R2", "Vout", "% Error", "Current"]
result_pt.align = "r"
result_pt.add_rows(result_sorted)
print(result_pt)
