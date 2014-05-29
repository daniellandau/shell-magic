import pickle
import fileinput

# run this like so:
# stdbuf -o0 xinput test 2 | stdbuf -o0 grep press --color=none | stdbuf -o0 gawk '{print $3;}' | python collect.py

try:
  codes = pickle.load(open("/users/dlandau/key_stats", "r"))
except:
  codes = []
  for i in xrange(255):
    codes.append(0)
i = 0
while True:
  line = raw_input()
  try:
    key_code = int(line)
    codes[key_code] += 1
  except:
    pass
  i += 1
  if i % 10 == 0:
    pickle.dump(codes, open("/users/dlandau/key_stats","w"))
