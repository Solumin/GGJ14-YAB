local formations = {}
-- boats = width 75, height 34
-- police = width 64 height 29
-- tug = width 27 height 19
formations[1] = {
    {enemy = "red", x = 805, y = 100},
    {enemy = "red", x = 825, y = 180},
    {enemy = "red", x = 845, y = 260}}

formations[2] = {
    {enemy = "blue", x = 805, y = 100},
    {enemy = "blue", x = 825, y = 180},
    {enemy = "blue", x = 845, y = 260}}

formations[3] = {
    {enemy = "green", x = 805, y = 100},
    {enemy = "green", x = 825, y = 180},
    {enemy = "green", x = 845, y = 260}}

formations[4] = {
    {enemy = "red", x = 800, y = 100},
    {enemy = "blue", x = 800, y = 150},
    {enemy = "green", x = 800, y = 200},
    {enemy = "blue", x = 800, y = 250},
    {enemy = "red", x = 800, y = 300}}

formations[5] = {
    {enemy = "green", x = 800, y = 100},
    {enemy = "blue", x = 800, y = 150},
    {enemy = "red", x = 800, y = 200},
    {enemy = "blue", x = 800, y = 250},
    {enemy = "green", x = 800, y = 300}}

formations[6] = {
    {enemy = "green", x = 820, y = 200},
    {enemy = "green", x = 820, y = 400}}

formations[7] = {
    {enemy = "police", x = -40}}

formations[8] = {
    {enemy = "police", x = -120},
    {enemy = "police", x = -40}}

formations[9] = {
    {enemy = "tugboat", x = 810}}

--formations[10] = {
--    {enemy = "tugboat", x = 810}}

return formations
