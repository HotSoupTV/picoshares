pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
--lexicon in puterspace
--an rpg by lemmo

--version 3
--map works, monsters need work

-- dialogue text box library by oli414. minimized.
function dtb_init() dtb_q={}dtb_f={}dtb_n=3 _dtb_c() end function dtb_disp(t,c)local s,l,w,h,u s={}l=""w=""h=""u=function()if #w+#l>29 then add(s,l)l=""end l=l..w w=""end for i=1,#t do h=sub(t,i,i)w=w..h if h==" "then u()elseif #w>28 then w=w.."-"u()end end u()if l~=""then add(s,l)end add(dtb_q,s)if c==nil then c=0 end add(dtb_f,c)end function _dtb_c()dtb_d={}for i=1,dtb_n do add(dtb_d,"")end dtb_c=0 dtb_l=0 end function _dtb_l()dtb_c+=1 for i=1,#dtb_d-1 do dtb_d[i]=dtb_d[i+1]end dtb_d[#dtb_d]=""sfx(62)end function dtb_update()if #dtb_q>0 then if dtb_c==0 then dtb_c=1 end local z,x,q,c z=#dtb_d x=dtb_q[1]q=#dtb_d[z]c=q>=#x[dtb_c]if c and dtb_c>=#x then if btnp(4) then if dtb_f[1]~=0 then dtb_f[1]()end del(dtb_f,dtb_f[1])del(dtb_q,dtb_q[1])_dtb_c()sfx(62)return end elseif dtb_c>0 then dtb_l-=1 if not c then if dtb_l<=0 then local v,h v=q+1 h=sub(x[dtb_c],v,v)dtb_l=1 if h~=" " then sfx(62)end if h=="." then dtb_l=6 end dtb_d[z]=dtb_d[z]..h end if btnp(4) then dtb_d[z]=x[dtb_c]end else if btnp(4) then _dtb_l()end end end end end function dtb_draw()if #dtb_q>0 then local z,o z=#dtb_d o=0 if dtb_c<z then o=z-dtb_c end rectfill(2,125-z*8,125,125,0)if dtb_c>0 and #dtb_d[#dtb_d]==#dtb_q[1][dtb_c] then print("\x8e",118,120,1)end for i=1,z do print(dtb_d[i],4,i*8+119-(z+o)*8,7)end end end
--end dialog text box by oli414
--use dtb_disp(txt, callback) to write to text box

function _init()
 dtb_init() --activate text box
 screen = {}
 entity = {}
 animation = {}
 danger = {}
 stars = {}
 --game globals
 game_mode = 0
 game_speed = 16
 game_over = false
 game_menu = false
 game_busy = false
 game_busy_timer = 0
 game_battle = false
 game_special = false
 game_diff = 0
 game_threat = 0
 game_debug1 = 0
 game_debug2 = 0
 game_map = 0
 game_spawn = 0
 game_tractor_y = 0
 game_tractor_frame = 220
 game_tractor_sprite = 42
 game_tractor_timer = .5
 game_tractor_off = false
 game_boss_1 = false --miniboss flag
 game_boss_2 = false --boss flag
 --savegame globals
 save_r = 5
 save_o = 10
 save_j = 10
 save_g = 5
 save_b = 5
 save_l = 10
 save_xp = 1

 fade_palette={
  {1,1,1,1,0,0,0,0},
  {2,2,2,1,1,1,0,0},
  {3,3,3,5,5,1,1,0},
  {4,4,2,2,2,1,0,0},
  {5,5,5,1,1,1,0,0},
  {6,6,6,5,5,1,1,0},
  {7,7,7,6,6,5,5,1},
  {8,8,8,4,4,2,1,0},
  {9,9,4,2,2,1,0,0},
  {10,10,10,14,14,8,2,1},
  {11,11,3,3,3,1,1,0},
  {12,12,13,2,2,1,0,0},
  {13,13,13,2,2,1,1,0},
  {14,14,8,8,2,1,1,0},
  {15,15,14,8,8,2,1,1}}

 doors = { --newx must always be *8
 {id=7,map=1,newx=24,newy=47}, --home
 {id=11,map=0,newx=24,newy=24}, --out home
 {id=25,map=2,newx=48,newy=79}, --building 1
 {id=17,map=0,newx=24,newy=47}, --building 1
 {id=24,map=2,newx=85,newy=6}, --building 2
 {id=21,map=0,newx=24,newy=47} --building 2
 }

 dialogs = {
 {id=12,text="hello lexicon! my system is swarming with bugs! either delete them with your linebreaker, or capture them when they're weak with your catchahedron! try to find the source of all this bad code, and good luck!",read=false}
 }

 maps = {
 {id=0,x=0,y=0,w=64,h=64},
 {id=1,x=64,y=0,w=8,h=10},
 {id=2,x=72,y=0,w=19,h=14}
 }

 make_screen("map",0,0,128,128) --map screen
 make_screen("menu",0,0,128,128) --inventory screen
 make_screen("battle",0,0,128,128) --battle screen

 add_frame("leximap",0,0,.5,0,false) --stand
 add_frame("leximap",1,2,.5,1,false) --walk l/r
 add_frame("leximap",2,3,.5,17,false)
 add_frame("leximap",3,4,.5,33,false)
 add_frame("leximap",4,5,.5,49,false)
 add_frame("leximap",5,6,.5,17,false)
 add_frame("leximap",6,1,.5,33,false)
 add_frame("leximap",7,8,1,32,false) --up
 add_frame("leximap",8,7,1,32,true)
 add_frame("leximap",9,10,1,16,false) --down
 add_frame("leximap",10,9,1,16,true)
 add_frame("lexicon",100,101,.5,18,false,2) --running
 add_frame("lexicon",101,102,.5,20,false,4)
 add_frame("lexicon",102,103,.5,50,false,34)
 add_frame("lexicon",103,100,.5,20,false,4)
 add_frame("lexicon",104,105,.5,36,false,38) --shooting
 add_frame("lexicon",105,106,.5,52,false,38)
 add_frame("lexicon",106,107,.5,54,false,38)
 add_frame("lexicon",107,104,.5,52,false,38)
 add_frame("lexicon",108,108,1,56,false) --ko
 --create animations for monsters
 add_frame("bee",200,201,.1,6,false)
 add_frame("bee",201,200,.1,22,false)
 add_frame("bat",202,203,1,7,false)
 add_frame("bat",203,202,1,23,false)
 add_frame("slime",204,205,4,8,false)
 add_frame("slime",205,204,1,24,false)
 add_frame("spider",206,207,1,9,false)
 add_frame("spider",207,206,1,9,true)
 add_frame("orc",208,209,1,10,false)
 add_frame("orc",209,208,1,26,false)
 add_frame("creeper",210,211,1,11,false)
 add_frame("creeper",211,210,1,27,false)
 add_frame("momzer",212,213,1,12,false)
 add_frame("momzer",213,212,1,28,false)
 add_frame("ghost",214,215,.5,13,false)
 add_frame("ghost",215,214,.5,29,false)
 add_frame("bigvader",216,217,1,14,false)
 add_frame("bigvader",217,216,1,30,false)
 add_frame("midvader",218,219,1,15,false)
 add_frame("midvader",219,218,1,31,false)
 add_frame("diamond",220,221,.5,42,false)
 add_frame("diamond",221,223,.5,43,false)
 add_frame("diamond",222,220,.5,58,false)
 add_frame("diamond",223,222,.5,59,false)
 add_frame("skeleton",224,225,1,44,false)
 add_frame("skeleton",225,224,1,45,false)
 add_frame("dragon",226,227,1,46,false)
 add_frame("dragon",227,226,1,47,false)
 add_frame("aship",228,228,1,40,false)
 add_frame("gship",229,229,1,41,false)
 add_frame("robot",230,231,1,25,false)
 add_frame("robot",231,230,1,25,true)
 add_frame("eyeball",232,233,1,48,false)
end

--table update functions
function screen_palette(level)
 for c=1,15 do
  pal(c,fade_palette[c][level])
 end
end

function make_screen(id,x,y,w,h)
 local s = {}
  s.id = id
  s.windowx = x
  s.windowy = y
  s.windoww = w
  s.windowh = h
  s.camx = 0
  s.camy = 0
  s.mapx = 0
  s.mapy = 0
  s.mapw = 64
  s.maph = 64
  add(screen, s)
 return s
end

function make_entity(type,screen,frame,friendly,tone,sound,x,y,w,h,hb,flip,s,r,o,j,g,b,l)
 local e = {}
  e.type = type
  e.screen = screen
  e.frame = frame
  e.friendly = friendly
  e.tone = tone
  e.sound = sound
  e.blink = false
  e.x = x
  e.y = y
  e.w = w
  e.h = h
  e.hitbox = hb
  e.ko = false
  e.flip = flip
  e.f_flip = false
  e.sprite = 0
  e.timer = 1
  --combat attributes
  e.size = s
  e.damage = r
  e.rate = o
  e.speed = j
  e.regen = g
  e.shield = b
  e.life = l
  e.maxlife = l
  e.move = 1 --((game_speed/16)*e.speed)*e.size
  e.busy = 0
  e.reload = 0
  --battle commands
  e.raise=false
  e.lower=false
  e.back=false
  e.forward=false
 add(entity, e)
end

function add_frame(type,id,nextid,length,sprite,flip,topsprite)
 local frame = {}
  frame.type = type
  frame.id = id
  frame.nextid = nextid
  frame.length = length*game_speed
  frame.sprite = sprite
  frame.flip = flip
  frame.topsprite = topsprite
 add(animation,frame)
end

function create_danger(x,y,z,nx,ny,speed,damage,friendly,sound)
 local newdanger = {}
  newdanger.x=x
  newdanger.y=y
  newdanger.z=z
  newdanger.nx=nx
  newdanger.ny=ny
  newdanger.speed=(game_speed+speed)/game_speed
  newdanger.damage=damage
  newdanger.friendly=friendly
 add(danger,newdanger)
 sfx(sound)
end

-- starfield code by chase!
function rndchoice(t)
 return t[flr(rnd(#t))+1]
end

function makestars(n)
 local starcolors={1,5,6,7,13}
 for i=1,n do
  add(stars, {
   x=flr(rnd(128)),
   y=flr(rnd(88)),
   c=rndchoice(starcolors)
  })
 end
end
-- end starfield code

function flr8(i)
 i = flr(i/8)
 return i
end

function mapcheck(x,y,sx,sy)
 local mapx, mapy, mapz
  mapx = flr8(x)+sx
  mapy = flr8(y)+sy
  mapz = mget(mapx,mapy)
 return mapz
end

--game update functions
function update_danger(d)
 if d.z ~= nil then --angled shots
  d.x = d.x - d.speed * cos(d.z)
  d.y = d.y + d.speed * sin(d.z)
  d.nx = d.nx - d.speed * cos(d.z)
  d.ny = d.ny + d.speed * sin(d.z)
 else --straight shots
  if d.friendly then
   d.x += d.speed
   d.nx += d.speed
  else
   d.x -= d.speed
   d.nx -= d.speed
  end
 end
 if d.x < -10 or d.y < - 10 or d.x > 140 or d.y > 140 then
  del(danger,d) --shot out of screen
 end
 for e in all(entity) do --check to see if an entity is hit
  if d.x+2 > e.x and d.y-2 > e.y+(e.h*e.size*8)-(e.hitbox*e.size*8) and d.x+2 < e.x+(e.w*e.size*8) and d.y+2 < e.y+(e.h*e.size*8) then
   if d.friendly ~= e.friendly then --no friendly fire
    print(d.damage,8)
    e.life -= d.damage-(e.shield/4)
    sfx(32)
    del(danger,d) --shot out of screen
   end
  end
 end
end

function title_screen()
 if btn(4) then
  game_mode = 1
  make_entity("leximap","map",1,true,"white",0,8,8,1,1,1,false,1,1,1,1,1,1,1) --lexicon
  make_entity("lexicon","battle",100,true,"white",34,24,24,2,1,2,false,1,save_r,save_o,save_j,save_g,save_b,save_l)
 end
end

function check_battle() --no fighting for now
 if game_map == 0 then --for now battles are only for the overworld.
  if game_boss_1 then
   if(game_diff==97) build_battle(98)
  end
  if game_boss_2 then
   if(game_diff==190) build_battle(191)
  end
  game_threat += 1 --(comment this to turn off combat))
  if game_threat>rnd(1000)+300 then --a monstar appears!
   game_threat = 0
   game_battle = true
   game_busy = false --this should be true, once fade-in is working
   game_busy_timer = 0
   build_battle(game_diff)
  end
 end
end

function build_battle(diff) --name,screen,frame,friendly,tone,sound,x,y,w,h,flip,s,r,o,j,g,b,l
 game_tractor_off = false --tractor beam works once per battle

 local tier = flr(diff/10)+1
 local grade = flr(diff-(tier*10)+10)
 local build = grade --lets us build the number of baddies
 game_debug1=grade
 game_debug2=tier
 if build > 6 then
  make_monster(grade-4+rnd(5),tier,tier+2,tier+1) --hard baddy
  build -= 3
 end
 if build > 4 then
  make_monster(grade-4+rnd(5),tier,tier+1,tier) --medium baddy
  build -= 2
 end
 while(build>=0) do
  make_monster(grade-4+rnd(5),tier,tier,tier) --normal baddy
  build -= 1
 end
end

function make_monster(monster,lv,mjr,mnr)
 --each monster has a "monster" number relating to its difficulty. the game_diff is split up such that the difficulty is spread out across multiple monsters.
 --multiple monsters are also, in itself, an increase in difficulty, so subtract a fair aount when making this multiple monster calculation
 if(monster<=0) monster=1 --lowest is always a bee
 local w = rnd(64)+64
 local h = rnd(94)+16
 local size = 1
 if mjr>lv then --color the difficulty of the monster
  if mnr>lv then
   color = "red"
  else
   color = "orange"
  end
 else
  if mnr>lv then
   color = "yellow"
  else
   color = "blue"
  end
 end
 --monster list--------------------------------------------------------------------dmg,rate,spd,regen,shield,life---
 if(monster==1) make_entity("bee","battle",200,false,color,35,w,h,1,1,1,false,size,lv,mjr,lv,mnr,lv,lv*10)
 if(monster==2) make_entity("bat","battle",202,false,color,35,w,h,1,1,1,false,size,lv,mnr,mjr,lv,lv,lv*10)
 if(monster==3) make_entity("slime","battle",204,false,color,35,w,h,1,1,1,false,size,lv,lv,lv,mnr,lv,mjr*10)
 if(monster==4) make_entity("aship","battle",228,false,color,35,w,h,1,1,1,false,size,lv,mnr,mjr,lv,lv,lv*10)
 if(monster==5) make_entity("spider","battle",206,false,color,35,w,h,1,1,1,false,size,lv,mnr,lv,lv,mjr,lv*10)
 if(monster==6) make_entity("gship","battle",229,false,color,35,w,h,1,1,1,false,size,lv,mjr,mnr,lv,lv,lv*10)
 if(monster==7) make_entity("orc","battle",208,false,color,35,w,h,1,1,1,false,size,mjr,lv,lv,mnr,lv,lv*10)
 if(monster==8) make_entity("creeper","battle",210,false,color,35,w,h,1,1,1,false,size,mjr,mnr,lv,lv,lv,lv*10)
 if(monster==9) make_entity("momzer","battle",212,false,color,35,w,h,1,1,1,false,size,mnr,lv,lv,lv,lv,mjr*10)
 if(monster==10) make_entity("ghost","battle",214,false,color,35,w,h,1,1,1,false,size,lv,lv,mnr,mjr,lv,lv*10)
 if(monster==11) make_entity("bigvader","battle",216,false,color,35,w,h,1,1,1,false,size,mjr,lv,mnr,lv,lv,lv*10)
 if(monster==12) make_entity("midvader","battle",218,false,color,35,w,h,1,1,1,false,size,lv,mnr,mjr,lv,lv,lv*10)
 if(monster==13) make_entity("robot","battle",230,false,color,35,w,h,1,1,1,false,size,lv,mnr,lv,lv,mjr,lv*10)
 if(monster==200) make_entity("skeleton","battle",224,false,color,35,w,h,1,2,1,false,size,mnr,lv,lv,mnr,lv,mjr*10)
 if(monster==300) make_entity("dragon","battle",226,false,color,35,w,h,1,2,1,false,size,mjr,mnr,mjr,lv,mjr,mnr*10)
 if(monster==400) make_entity("eyeball","battle",232,false,color,35,w,h,1,1,1,false,size,mjr,mjr,mnr,mnr,mjr,mjr*10)
end

function behave_bee(e)
 e.back=false
 e.forward=false
 if e.busy == 0 then
  e.busy = 20/e.move
  e.raise=false
  e.lower=false
  if rnd(2)>1 then
   e.raise = true
  else
   e.lower = true
  end
 end
 if rnd(50)<1 then
  if e.reload == 0 then --shoot
   create_danger(e.x+(4*e.size),e.y+(4*e.size),nil,e.x+(4*e.size),e.y+(4*e.size),e.rate,e.damage,e.friendly,e.sound)
   e.reload = 20/e.rate
  end
 end
 if rnd(20)<1 then
  if rnd(2)>1 then
   e.forward = true
  else
   e.back = true
  end
 end
end

function behave_slime(e)
 if e.busy == 0 then
  e.busy = 50/e.move
  e.raise=false
  e.lower=false
  e.back=false
  e.forward=false
  if rnd(2)>1 then
   e.raise = true
  else
   e.lower = true
  end
  if rnd(2)>1 then
   e.forward = true
  else
   e.back = true
  end
 end
 if rnd(50)<1 then
  if e.reload == 0 then --shoot
   create_danger(e.x+(4*e.size),e.y+(4*e.size),nil,e.x+(7*e.size),e.y+(4*e.size),e.rate,e.damage,e.friendly,e.sound)
   e.reload = 40/e.rate
  end
 end
end

function behave_bat(e)
 if e.busy == 0 then
  e.busy = 10/e.move
  e.raise=false
  e.lower=false
  e.back=false
  e.forward=false
  if rnd(2)>1 then
   e.raise = true
  else
   e.lower = true
  end
  if rnd(2)>1 then
   e.forward = true
  else
   e.back = true
  end
 end
 if rnd(50)<1 then
  if e.reload == 0 then --shoot
   create_danger(e.x+(4*e.size),e.y+(4*e.size),nil,e.x+(7*e.size),e.y+(4*e.size),e.rate,e.damage,e.friendly,e.sound)
   e.reload = 40/e.rate
  end
 end
end

function behave_aship(e)
 if e.busy == 0 then
  e.busy = 50/e.move
  e.raise=false
  e.lower=false
  e.back=false
  e.forward=false
  if rnd(2)>1 then
   e.raise = true
  else
   e.lower = true
  end
  if rnd(2)>1 then
   e.forward = true
  else
   e.back = true
  end
 end
 if rnd(50)<1 then
  if e.reload == 0 then --shoot
   create_danger(e.x+(4*e.size),e.y+(4*e.size),nil,e.x+(7*e.size),e.y+(4*e.size),e.rate,e.damage,e.friendly,e.sound)
   e.reload = 40/e.rate
  end
 end
end

function behave_spider(e)
 if e.busy == 0 then
  e.busy = 10/e.move
  e.raise=false
  e.lower=false
  e.back=false
  e.forward=false
  if rnd(2)>1 then
   e.raise = true
  else
   e.lower = true
  end
  if rnd(2)>1 then
   e.forward = true
  else
   e.back = true
  end
 end
 if rnd(50)<1 then
  if e.reload == 0 then --shoot
   create_danger(e.x+(4*e.size),e.y+(4*e.size),nil,e.x+(7*e.size),e.y+(4*e.size),e.rate,e.damage,e.friendly,e.sound)
   e.reload = 40/e.rate
  end
 end
end

function behave_gship(e)
 if e.busy == 0 then
  e.busy = 50/e.move
  e.raise=false
  e.lower=false
  e.back=false
  e.forward=false
  if rnd(2)>1 then
   e.raise = true
  else
   e.lower = true
  end
  if rnd(2)>1 then
   e.forward = true
  else
   e.back = true
  end
 end
 if rnd(50)<1 then
  if e.reload == 0 then --shoot
   create_danger(e.x+(4*e.size),e.y+(4*e.size),nil,e.x+(7*e.size),e.y+(4*e.size),e.rate,e.damage,e.friendly,e.sound)
   e.reload = 40/e.rate
  end
 end
end

function enter_door(door)
 for d in all(doors) do
  if door==d.id then
  return d.map,d.newx,d.newy
  end
 end
end

function open_dialog(dialog)
 for d in all(dialogs) do
  if dialog==d.id and not d.read then
   dtb_disp(d.text)
   d.read=true
  end
 end
end

function next_frame(id)
 for f in all(animation) do
  if(f.id == id) return f.nextid,f.sprite,f.length,f.flip,f.topsprite
 end
end

function event_death()
 game_mode = 0
 for e in all(entity) do
  del(entity, e)
 end
 game_over = false
 _init()
end

function update_entity(e)
 local command = {}
-- end

 e.timer -= 1 -- countdown for animations
 if e.reload <= 0 then -- countdown reload
  e.reload = 0
 else
  e.reload -= 1
 end
 if(e.timer<=0) then
  e.frame,e.sprite,e.timer,e.f_flip,e.topsprite = next_frame(e.frame) --update animation
 end
 if not game_busy then --listen for button inputs
  if game_menu then
   command.up=btn(2,0)
   command.down=btn(3,0)
   command.left=btn(0,0)
   command.right=btn(1,0)
   command.select=btn(4,0)
   command.cancel=btn(5,0)
  else
   if game_battle then
    command.raise=btn(2,0)
    command.lower=btn(3,0)
    command.back=btn(0,0)
    command.forward=btn(1,0)
    command.shoot=btn(4,0)
    command.special=btn(5,0)
   else
    command.north=btn(2,0)
    command.south=btn(3,0)
    command.west=btn(0,0)
    command.east=btn(1,0)
    command.use=btn(4,0)
    --command.menu=btn(5,0)
   end
  end
 end --end button listen

 if command.cancel then --clean up menu
  game_menu = false
  game_busy = true
 end

 for s in all(screen) do --draw all the screens
  if s.id == "map" then --move on the map
   if e.type == "leximap" then --if entity matches player, do player stuff
    if(e.y<256) game_diff = flr8((e.x+e.y+10))+1--check difficulty
    if(e.y>=256) game_diff = flr8(e.y+10+abs(e.x-1024))+1
    if command.menu then
     game_menu = true
     game_busy = true
    end

    if not command.north and not command.south and not command.west and not command.east and not command.off then
     command.off = true
     e.anim = "stand"
     e.frame = 0
     e.timer = 0
    end

    if not command.off then
     e.flip = false
    end

    if not command.west and not command.east then --for diagonal walking
     if command.north then
      if e.anim ~= "walkup" then
       e.anim = "walkup"
       e.frame = 7
       e.timer = 0
      end
     end
     if command.south then
      if e.anim ~= "walkdown" then
       e.anim = "walkdown"
       e.frame = 9
       e.timer = 0
      end
     end
    end

    if command.north then
     if fget(mapcheck(e.x+1,e.y+5,s.mapx,s.mapy),0) and fget(mapcheck(e.x+6,e.y+5,s.mapx,s.mapy),0) then
      e.y -= 8/game_speed
      check_battle()
      if e.y < s.camy+(s.windowh/2) then
       s.camy -= 8/game_speed
      end
     end
    end

    if command.south then
     if fget(mapcheck(e.x+1,e.y+8,s.mapx,s.mapy),0) and fget(mapcheck(e.x+6,e.y+8,s.mapx,s.mapy),0) then
      e.y += 8/game_speed
      check_battle()
      if e.y > s.camy+(s.windowh/2) then
       s.camy += 8/game_speed
      end
     end
    end

    if command.east then
     if e.anim ~= "walk" then
      e.anim = "walk"
      e.frame = 1
      e.timer = 0
     end
     if fget(mapcheck(e.x+7,e.y+6,s.mapx,s.mapy),0) and fget(mapcheck(e.x+7,e.y+7,s.mapx,s.mapy),0) then
      e.x += 8/game_speed
      check_battle()
      if e.x > s.camx+(s.windoww/2) then
       s.camx += 8/game_speed
      end
     end
    end

    if command.west then
     if e.anim ~= "walk" then
      e.anim = "walk"
      e.frame = 1
      e.timer = 0
     end
     e.flip = true
     if fget(mapcheck(e.x,e.y+6,s.mapx,s.mapy),0) and fget(mapcheck(e.x,e.y+7,s.mapx,s.mapy),0) then
      e.x -= 8/game_speed
      check_battle()
      if e.x < s.camx+(s.windoww/2) then
       s.camx -= 8/game_speed
      end
     end
    end

    if command.use then --check for interactions
     if fget(mapcheck(e.x+1,e.y+5,s.mapx,s.mapy),1) and fget(mapcheck(e.x+6,e.y+5,s.mapx,s.mapy),1) or fget(mapcheck(e.x+1,e.y+8,s.mapx,s.mapy),1) or fget(mapcheck(e.x+6,e.y+8,s.mapx,s.mapy),1) then
      game_map,e.x,e.y = enter_door(game_diff)
      sfx(63)
     end
     if fget(mapcheck(e.x+1,e.y+5,s.mapx,s.mapy),2) and fget(mapcheck(e.x+6,e.y+5,s.mapx,s.mapy),2) or fget(mapcheck(e.x+1,e.y+8,s.mapx,s.mapy),2) or fget(mapcheck(e.x+6,e.y+8,s.mapx,s.mapy),2) then
      open_dialog(game_diff)
     end
    end
   end --close map loop
  end --close lexicon loop

  if e.screen == "battle" then --update everyone in the fight
   if e.life <= 0 then
    if e.type == "lexicon" then
     game_over = true
     game_battle = false
     event_death()
    else
     e.ko = true
     if(not e.friendly) save_xp += e.damage+e.speed+e.reload+e.regen+e.shield+e.maxlife --getxp!
     sfx(33)
    end
    e.ko = true --die die die!
   end
   e.move = (e.speed*e.size)/game_speed --determine move
   e.busy-=1
   if(e.busy<=0)e.busy=0
   --monster behavior calls
   if(e.type=="bee") behave_bee(e)
   if(e.type=="bat") behave_bat(e)
   if(e.type=="slime") behave_slime(e)
   if(e.type=="aship") behave_aship(e)
   if(e.type=="spider") behave_spider(e)
   if(e.type=="gship") behave_gship(e)
   --end monster calls
   if e.friendly then --stuff for the left side
    if e.type == "lexicon" then --if entity matches player, do player stuff
     e.size=1 --make sure she's normal sized
     game_tractor_y = 0
     e.raise=command.raise
     e.lower=command.lower
     e.back=command.back
     e.forward=command.forward
     if command.special then
      if game_tractor_off then --used up for now
       --sfx(broken tractor beam)
      else
       game_tractor_y = e.y-2
       if e.anim ~= "shoot" then
        e.anim = "shoot"
        e.frame = 104
        e.timer = 0
       end
      end
     end
     if command.shoot then
      if game_tractor_y <= 0 then --can't shoot while beaming
       if e.anim ~= "shoot" then
        e.anim = "shoot"
        e.frame = 104
        e.timer = 0
       end
       if e.reload == 0 then
        create_danger(e.x+16,e.y-2,nil,e.x+20,e.y-2,e.rate,e.damage,e.friendly,e.sound)
        e.reload = (2*game_speed)/(e.rate/10)
       end
      end --end beamcheck
     end
     if not command.shoot and not command.special then
      --if nothing else, do the running lexi
      if e.anim ~= "run" then
       e.anim = "run"
       e.frame = 100
       e.timer = 0
      end
     end
    else --not lexi, must be monster buddies
    e.flip = true --buddy monsters face forward
    end --close lexicon if
    if e.back then
     if(e.x>0) e.x -= e.move
    end
    if e.forward then
     if(e.x<56) e.x += e.move
    end
    if(e.x<0)e.x=0
    if(e.x>56)e.x=56
   else --stuff for the right side (enemies!)
    if e.forward then --forward and back are reversed for other side!
     if(e.x>64) e.x -= e.move
    end
    if e.back then
     if(e.x<120) e.x += e.move
    end
    if game_tractor_y > 0 then
     if e.size == 1 then --only tow normal sized monsters
      if e.y-4 < game_tractor_y and e.y+4 > game_tractor_y then
       e.x -= ((e.maxlife-e.life)/e.maxlife)/(game_speed/4)
       if e.x<=56 then
        e.friendly=true --captured enemies become friendlies
        game_tractor_off = true
       end
      end
     end
    else
     if(e.x<64)e.x=64
     if(e.x>120)e.x=120
    end
   end   --close friendly if
   if e.raise then
    if(e.y>16) e.y -= e.move
   end
   if e.lower then
    if(e.y<104+(e.h*8)) e.y += e.move --if this works, it should allow all height monsters to go low enough to shoot eachother
   end
   if(e.y<16)e.y=16
   if(e.y>112)e.y=112
  end --close battle if
 end --close screen loop
 if(e.f_flip) e.flip = true
end

function fade_in()
 if game_busy then --fade out the map
  game_busy_timer += 1
  if game_busy_timer == 8 then
   game_busy = false
   game_busy_timer = 8
  else
   screen_palette(game_busy_timer)
  end
 end
end

function fade_out()
 if game_busy then -- fade the map back in
  game_busy_timer -= 1
  if game_busy_timer == 0 then
   game_busy = false
   game_busy_timer = 0
  else
   screen_palette(game_busy_timer)
  end
 end
end

function draw_screen(s)
 for m in all(maps) do
  if m.id == game_map then
   s.mapx = m.x
   s.mapy = m.y
   s.mapw = m.w
   s.maph = m.h
  end
 end

 clip(s.windowx,s.windowy,s.windoww,s.windowh) --defines screen placement/size
 camera(s.camx,s.camy)

 if s.id == "map" then --draw the map
  if game_battle then
  --draw that cool star field
  else
   if game_menu then --turn on the menu
    pal(1,0) pal(2,0) pal(3,0) pal(4,0) pal(5,0) pal(8,1) pal(13,1) --darks to black
    pal(6,2) pal(7,2) pal(9,2) pal(10,2) pal(11,2) pal(12,2) pal(14,2) pal(15,2) --lights to maroon
   end
   map(s.mapx,s.mapy,s.windowx,s.windowy,s.mapw,s.maph)
   draw_entities(s) --map entities
   pal()
  end
 end

 if game_battle then --turn on the menu
  if game_busy then
   fade_in()
  else
   cls()
  end
 else
  fade_out()
 end
 --end --end map draw

 if s.id == "menu" then --draw the menu (on top of the map)
  if game_menu then
   pal()
   palt()
   --menu art goes here
   rect(5,5,122,122,8)
   local ecount=0
   for e in all(entities) do
    if e.friendly then
     if e.type == "lexicon" then
      e.size = 4
      e.x = 48
      e.y = 48
     else
      e.y = 90
      e.x = 48+(ecount*12)
      ecount+=1
     end
    end
   end
   draw_entities(s)
  end
 end --end menu draw

 if s.id == "battle" then --draw the battle screen
  if game_battle then
   rect(0,16,63,127,6)
   rect(64,16,127,127,14)
   --battle art goes here
   draw_entities(s)
   draw_danger()
  end
 end --end battle draw
 clip()
 camera()
end

function draw_danger()
 for d in all(danger) do
  line(d.x,d.y,d.nx,d.ny,7)
 end
end

function draw_gun(e)
 if game_tractor_y > 0 then
  game_tractor_timer -= 1
  if(game_tractor_timer <= 0) game_tractor_frame,game_tractor_sprite,game_tractor_timer = next_frame(game_tractor_frame)
  palt()
  spr(game_tractor_sprite,48,game_tractor_y)
  line(56,game_tractor_y+4,128,game_tractor_y+rnd(8),flr(rnd(6)+6)) --crackle beam
  line(e.x+14,game_tractor_y,51,game_tractor_y+rnd(8),flr(rnd(4))) --control beam
  line(e.x+11,e.y-2,e.x+12,e.y-2,4) --lexi's arm
  line(e.x+5,e.y,e.x+8,e.y,4) --lexi's arm
  rect(e.x+13,e.y-2,e.x+14,e.y-1,4) --lexi's fist
  pset(e.x+12,e.y-2,6) --lexi's elbow
  pset(e.x+13,e.y-2,5) --lexi's wrist
 else
 --this can get more complex once we have multiple gun types
  line(e.x+5,e.y-2,e.x+13,e.y-2,13)
  line(e.x+7,e.y-2,e.x+12,e.y-2,6)
 end
end

function draw_computer(s)
 circfill(s.mapx-39,s.mapy+27,2,7)
 circfill(s.mapx-26,s.mapy+27,2,7)
 line(s.mapx-39,s.mapy+34,s.mapx-26,s.mapy+34,7)
 line(s.mapx-37,s.mapy+35,s.mapx-28,s.mapy+35,7)
end

function draw_sprite(s,e)
 pal()
 palt()
 if e.type == "leximap" or e.type == "lexicon" then --lexicon
  palt(0,false) palt(7,true)
  if e.tone == "red" then pal(6,8) pal(13,2) end
  if e.tone == "orange" then pal(6,9) pal(13,5) end
  if e.tone == "yellow" then pal(6,10) pal(13,9) end
  if e.tone == "green" then pal(6,11) pal(13,3) end
  if e.tone == "blue" then pal(6,12) end
 else
  if e.tone == "red" then pal(7,14) pal(6,8) pal(13,2) end
  if e.tone == "orange" then pal(7,9) pal(6,4) pal(13,2) end
  if e.tone == "yellow" then pal(7,10) pal(6,15) pal(13,9) end
  if e.tone == "green" then pal(7,11) pal(13,3) pal(6,13) end
  if e.tone == "blue" then pal(7,12) pal(13,1) pal(6,13) end
 end
 if e.size ==1 then
  spr(e.sprite,e.x+s.windowx,e.y+s.windowy,e.w,e.h,e.flip)
 else
  sspr(flr(e.sprite*8%128),flr(e.sprite*8/128)*8,e.w*8,e.h*8,e.x+s.windowx,e.y+s.windowy,e.w*e.size*8,e.h*e.size*8,e.flip)
 end
 if e.topsprite then
  if e.size ==1 then
   spr(e.topsprite,e.x+s.windowx,e.y+s.windowy-(e.h*8),e.w,e.h,e.flip)
  else
   sspr(flr(e.topsprite*8%128),flr(e.topsprite*8/128)*8,e.w*8,e.h*8,e.x+s.windowx,e.y+s.windowy-(e.h*8),e.w*e.size*8,e.h*e.size*8,e.flip)
  end
 end
end

function draw_entities(s)
 if game_map == 1 then --we're in the house, draw the computer
  draw_computer(s)
 end
 for e in all(entity) do
  if s.id == e.screen then --draw only the entities for current screen
   draw_sprite(s,e)
   if e.anim == "shoot" then
    draw_gun(e)
   end
   if game_battle then --life bars
    line(e.x,e.y+9,e.x+(8*e.w),e.y+9,5)
    if e.friendly then
     line(e.x,e.y+9,e.x+((e.life/e.maxlife)*(8*e.w)),e.y+9,11)
    else
     line(e.x,e.y+9,e.x+((e.life/e.maxlife)*(8*e.w)),e.y+9,8)
    end
   end
   pal()
  end --end current screen
  if s.id == "menu" then --we need to draw the inventory friendlies
   if(e.friendly) draw_sprite(s,e)
  end
 end
end

-- pico functions (core loop)
function _update60()
 dtb_update() --update text box
 foreach(entity, update_entity)
 foreach(danger, update_danger)
 if game_battle then --is the battle over?
  local monsters=0
  for e in all(entity) do
   if not e.friendly then
    if not e.ko then
     monsters+=1
    else
     del(entity, e)
    end
   end
  end
  if monsters==0 then --all monsters dead!
   game_battle = false
   for e in all(entity) do
    if(e.friendly) e.life=e.maxlife --give all friendlies full health
   end
  end
 end
end

function _draw()
 cls()
 --draw each screen
 if game_mode == 0 then
   rectfill(4,4,123,123,2)
   print("#   ### # # ### ### ### ## ",10,32,1)
   print("l   #e   x   i  c   o # n #",10,38,1)
   print("### ### # # ### ### ### # #",10,44,1)
   print("#   ### # # ### ### ### ##",10,30,7)
   print("l   #e   x   i  c   o # n #",10,36,15)
   print("### ### # # ### ### ### # #",10,42,14)
   print("press [x] to start!",25,60,12)
   circfill(44,100,20,1)
   circfill(48,88,18,1)
   circfill(58,78,12,1)
   circfill(68,88,18,1)
   circfill(60,95,16,13)
   circfill(61,98,16,1)
   rectfill(54,118,62,121,5)
   rectfill(54,122,62,123,4)
   circfill(64,105,16,4)
   rectfill(40,98,56,106,5)
   rectfill(50,96,82,108,13)
   circfill(56,88,4,1)
   circfill(49,115,3,1)
   circfill(60,102,4,6)
   circfill(60,104,4,13)
   circfill(74,102,4,6)
   circfill(74,104,4,13)
   rectfill(59,111,72,112,7)
   rectfill(59,113,72,116,2)
   rectfill(59,115,67,116,14)
   rectfill(59,116,69,116,14)
   title_screen()
 end
 if game_mode == 1 then
  foreach(screen, draw_screen)
  print(game_debug1)
  print(game_debug2)
  print(game_diff)
  dtb_draw()--draw textbox
 end
end

__gfx__
701d1107701d1107770111100777777770111dd1107777770000ddd00000000000000000050005000000000000d7d6000060060000677600000dd00007000070
01d1551001d1151070111dd1107777770111d15551077777000d505d00606000000600005750575000600600007576000d777760067777600d7777d000600600
01156d60011156d00111d15551077777011115dddd07777700d5050d00777000006670007d757d75007667000055560007d7d76d65d75d76677777760d7777d0
0111441001114410011115dddd007777011114d6d607777700d050d00707077d06666760d07760d70507075000575d0007777776675775767007700766077066
701dd107701dd107011114d6d64407777011114440777777605ddd000777777d6606066600d7770d057777570005d000065657d675d75d777777777776777767
77046d40704064077001114440440777701166ddd607777707d5756d0d7076d066060dd60077657066777667000760000000076d77777777767777677d7667d7
7770550777005560777066ddd60507777700466d6407777706d565d00d606d000ddddd600756d057070dd0770077670007777776677777767560065705700750
77060607770600077704466d6446077777046546407777770000000000d0d00000666600750000000067660006606600677067760d6d0d6d570dd07500577500
70d11107701d110770600066000077777770044554077777000000000d000d00000000000067760000600600007d66000060060000677600000dd00007000070
0d111d1001d115107054005550777777777055555077777700000000d60006d0000000000070d70000766700005766000d777760067777600d7777d050600605
01155110011156d070440555550777777777055540777777000000006000006d0006000067777776050707500055660007d7d76d65d75d76677777767d7777d7
7056651001114410770005540407777777777041d07777770005dddd7060607d006666007d7777d70566665700756d0007777776675775767007700776077067
70d44d07701dd107706d6440706000777777060660777777605555007777777d066677607077770707777707000d5000076d677675d75d777777777767777776
704d640777046d4070d1000770d1d607777011000777777707d5756dd707077d66060dd6007dd760660dd667000760000777777677777777d777777d06766760
7705507777065507706107777011d077777061107777777706d565d00d777dd06dddddd606700770070dd0700077670007777d6d677777765760067505700750
7770607777700607706077777706077777770d660777777700000000000d0d000666666007700000006766000066066067706776d6d0d6d0760dd06757000075
77055077701d11077701111007777777777770660777777777701111007777770000000000000000000000000000000000677760006777607000760000006600
7051150701d11510701111d1107777777777705550777777777011dd110777770000006d0006760000006000000070000655755606557556d757556000070760
0111d110011156d001111d1551077777777705555507777777011d15551077770000677000007760000667000006760006576756065767560d77776067777760
01111d1001114410011111dddd00077777000554040777777701115dddd07777006777d00067d77600666770006777600677577606775776007d7600ddd67600
01111107701dd1077011114d6d044077706d6440706000777011114d6d60777767777700677d06700777777707777777007676707076767007d0700000007000
7011140777006407770111144005407770d1000770d1d6077701111444077777006777d00067d77600dd666000d666d0700555007006d6006d06760000067600
77055077770556077705566444460777706107777011d0777770166ddd6077770000677000007760000d6600000d6d0070d6d6d070d565d05067776000677760
77706077777060777044066660007777706077777706077777770466d64407770000006d00067600000060000000600076677776767777660675557006755570
05676650701d1107704400660777777777770066077777777777706607777777777777777007777700000000000000007675656776756567775d5570775d5570
5676676501d11510770000555077777777705555507777777770005550777777777777700110077700007000000060007607670660076767675dd570675dd570
676d6776011156d0770d6555550777777777055540777777770d655555077777777777011111107700076700000766006065656000656566d6755760d6755760
67d076660111441070d115400440777777777041d077777770d11540044077777777701111111107007666700077666000766600000666700066760000667600
76d00d677011d14006d1640706007777777706066077777706d164070600777777007011111dd110077777770777777706500070007006500000600000006000
676dd67677046d07700000770d1d07777770110007777777700000770d1d07777061000141111110006ddd6000666dd00060065006500060d676d000600076d0
56666665777055607777777701166077777061107777777777777777011660770d1d5554664155110006d60000066d0067600060006076766000000006000060
05666650770600077777777706d0077777770d66077777777777777706d00777664455654644dd1d0000d000000060000000767667600000d670000000d676d0
11111111000000001111111188888888000000255555200255552000000000003366771333333333000000000000000066733667166666611111111155555555
5222222121111110dd2d2dd28888888800055553333355553333550077d777d77d6667d777d777d70000077777777777d5677d5666dddd656555555555555565
2522222112111110dd2d2dd288888888005333333333333333333500656f656f61666616656f656f0007766666666666ddd56ddd6dd66dd76777777755d55555
2252222111211110552d2552888888880053333333333333333335000000000033666611333333330076677777777777555115556d6dd6d76dddddd755555555
1111111100000000d2452444888888880053333333333333333335000000000033555511333333330767777777777777667336676d5dd5d76dddddd75555d6d5
2222522111112110d2dd2dd2888888880533333333333333333333500000000033dddd11333333330767777766666666d5677d566dd55ddd6555555d555d006d
2222252111111210d2dd2dd2888888885333333333333333333333350000000033dddd11333333337677777677777777ddd56ddd65dddd5565555555d555ddd5
222222511111112052552552888888885333333333333333333333350000000011dddd111111111176777767000000005551155515d777511111111155655555
66666676d766f66d1111111188888888233333333333333333333332dd7777dd3353353611111111767777673333333311111111555555551d6666d155555555
55dddddd76f676f755d5555588888888d2333333333333333333332d6700007693933533111111116777776733d333351111111150000015165dd76155d5d755
666667766f666666d55555d688888888525333333333333333333525600d0006333336331111111377777670333333331111111150010115155dd75155556605
555ddddd6766f6d655556d5588888888d2533333333333333333352d60d000065563333911111113777776703333d7331111111151111115155dd75156555555
66667776f66f66665d6d55558888888851533333333333333333351560000006333333331111113377766700353366031111111155555555155dd75155555555
5555dddd6666666d6d55555d888888881533333333333333333333516d0000d656333365111111336667700033333335111111116dd6ddd6155dd7515d6d555d
666777766f6d666655555d55888888885333333333333333333333356dddddd6353393531111133377700000335333d3666666666d6ddd66155dd751d006d655
55555dddd7666d6ddddddddd8888888853333333333333333333333516666661353353531111133300000000333333335555555566ddd6d615d777515ddd5555
d050055d111011011011110107011070533333333333333333333335dd7777dd111111111111333332555523d3d7335355555555d666666d1d6666d155555555
d500550d55505505502222050000000053333333333333333333333567777776dd5555dd11113333262dd262356603335555555555555555165dd761555555d5
d005500d101101111022220111000011233333333333333333333332677777765566665511133333525555253333333d5555555550000005155dd75156555555
0dddddd0505505555022220555000055d2333333333333333333332d67777776d6cccc6d111333335d5dd5d535333d3355555555500000051555575155555555
d055000d1110110110fd2201111011015253333333333333333335256777777656cccc65113333335d5dd5d5d335335355555555500000051567775155555555
d550005d555055055052220555505505d2533333333333333333352d66777766d677776d11333333525555253d733d3355555555555555551600107155555555
d500050d1011011110222201101101115225555333355553333552256d6666d65655556513333333262dd2623660533555555555333223333600106355d55555
0dddddd050550555515555155055055522122225555222255552221216666661dddddddd13333333325555233533353355555555333551133366663355555555
77777777111111111111111111111111521125125215251252112512335335355555555553535353333dd3333333335311111111b4bbdbbd5355353555555555
77666667ddddddddd222222d66d166c152512112521522125251211203030303515151510000000336dddd633335333311111111aa43bffb3533d5535dd66d05
666666666677ddd662000026111111112221211222152222122121123333535315151515050515013d5555d3333333331111111199ccbeeb3d535335d50d77d0
66666666dddd77ddd200002d6c1666d1222125122255555512202510556335395100510000000001dd5dd5dd33333d331111111134dd4bbd5333d35dd6000d6d
6666666667dddd76626d0026cc1dddd12211211225533335121011103353335300510051dddd6661dd5dd5ddd333333511111111db4baa4333533d355d6666d5
66666666dd77ddddd250002d111111115211211255333335101010105353333500000000414141413d5555d33333333311111111bff499cc5d53535d555d5555
666666666ddd7666620000261666c16d52512112525333525050101003030303510051005353535336dddd6333533333111111113ee3b4dd5535dd535555555d
55555555ddddddddd255552d1cccc1dd225121122255551200500010353353530000000033333333333dd3333333333311111111533533535d53535555556555
47474747474747474747474757474747474747474747474747474747474747474747474747476747474747674747474757676747474747000000000000000006
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
67674747574747476747474767676747474757676747476747474747474767676767474767670047476767004757676767446467475747000000446400000006
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000067676767676700476767000000676767670000675700676757476767000000006767000000676700000057670000445555646767674454545555545454a6
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000067000000000000000000000000670000006767000000445464000000000000004464006700004455555555545454555555555555555565
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00004454545464000000000000004454545464445454640000000044545454555555545454640000445555545454545555555555555555555555555555555565
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00005555555555545454545454644555555555555555555464445455555555555555555555555464455555555555555555555555555555555555555555555565
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00005555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555565
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00445555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555565
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555565
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
45555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555565
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
45555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555565
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
45555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555565
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
45555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555565
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
45555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555565
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
45555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555565
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
45555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555565
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
45555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555565
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
45555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555565
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
45555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555565
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
45555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555565
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
45555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555565
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
45555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555565
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
45555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555565
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
45555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555565
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
45555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555565
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
45555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555565
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
45555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555565
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
45555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555565
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
46555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555565
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
47465656565656565656565656565656565656565656565656565656565656565656565656565656565656565656565656565656565656565656565656565666
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
67474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474747474767
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
77676767676767676767676767676767676767676767676767676767676767676767676767676767676767676767676767676767676767676767676767676777
__gff__
0001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001010000010101000000010100000001010100000101010401010101000000010100020001010104000101010100000100000200000000010000010101000101
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
00444545454546004445454545707070704e4e4e4e4e4e4e7070707000000000000000004445460000000000004445460000004445460000000044454600000073737373737373737373737373737373737373737373737373737300000000000000000000000000000000000000000000000000000000000000000000000000
44557373734949474948494949715e715e45460044454545525e5e5200000000004446445555660000000000445555554600005455560000444555555545460073525252525252737352525273525273525273525273525252527300000000000000000000000000000000000000000000000000000000000000000000000000
54554272426956006455555555555e697373734555555555555e5e69460000444555555555667400000000005455555555454555555545455555587d585555467341707070705e737341404073414073414073414073414040407300000000000000000000000000000000000000000000000000000000000000000000000000
547b5550695566007654555555555e554268427c5555557b555e5e555545455555555555667676004a4b4b4b6a5555555555555555555555557d5855587d555673677c7c7c7c5e737341404052414052414052414052414040407300000000000000000000000000000000000000000000000000000000000000000000000000
64655551556675004455557b73737363734242595555557b554d5e4d5555655555555566764a4b4b5a00000054555555555555555555555558587a7a7a58585673705c5c5c5c57737341404040404040404040404040404040407300000000000000000000000000000000000000000000000000000000000000000000000000
76747460747476005455557b737373507372426955555555556e5e5e7c567654556d56744a5a0000000000005455555555555555555555557d557a6a7a557d5673414040404040737341405d5d40405d5d4040407341404040407300000000000000000000000000000000000000000000000000000000000000000000000000
44454560454545455555555568716871686a7a7a7a7a5555556b5e5e5955455555556a4b5a0000000000000064555555555555555555555558587a7a7a58585642414d504d4040427341404040404040404040407341404040404200000000000000000000000000000000000000000000000000000000000000000000000000
5455555155557b7b5555555568716871687c5555557a5555557e4d4e4d555555555556760000000000000000745455555555555555555555557d5855587d555642424272424242427352525252505252525273424272424242424200000000000000000000000000000000000000000000000000000000000000000000000000
547b55517d555555556d557d687168716859557b557a55557b70705e5e7c5555555555454600444546000000745455554e4e4e4e4e4e4e4e4e55587d5855555678787850787878787341404040404040404073787878787878787800000000000000000000000000000000000000000000000000000000000000000000000000
54557d5151515151515151516871727168695555557a55555571524d4d595555555555555545555555460000766455554e4e684e4e4e684e4e7c55555555555600000000000000007341404040404040404073000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5455587d555555556565555151516a517a7a7a7a7a7a55555571525e71695555555555555555555555554600007464554e4e714e4e4e714e4e7c55555555555600000000000000006841404068406840404068000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
54555555555555667675647d7d7d7d7d7d585555555555555555555e695555557b7b7b7b5555555555555545467674547168716871687168715955555555555600000000000000007171717171727171717171000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
64557070707b56760076767654555858587b7b7b555555554d4e4e4d55557b7b7b5b7e6b7b55555555555555560074647171717172717171716955555555555600000000000000007878787878787878787878000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
74647171714849474957460054557b7b77587758555555655e596565557b556b5b5b6b5555557b555555555555467674527d7d5250527d7d525555555555555600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7676747474767600647b660054557979777b587b555556745e75747454556b6b7e7b55556555555555555555555546767564485555555555555555555555555600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0044454546000000786078005455797779797b554d4e4e4e4d74767664557e5b7b7b65667464655555555555555566007674484848484848485555555555555600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
445555555600000000600044557b7b5877797b555e5956767676000076547b7b555676747674745455555555555674444676746455555555555555555555555600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
54555555554545454560455555557b7b7b7b58555e6956000000004448494949494947474846756465555555555545555546747454555555555555555555555600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
54554d704d5555557b7b7b5555555555555555555e555545464445656674545b556600445556767444555555555555555556767554555555555555555555555600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
54557052705555557b7b555555555555555555555e5555555555667474765455567600545556007654555555555555555556007654555555555555555555555600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
54554d714d55555555555555555555554d4e4e4e4d555b555556747644456b5b5b4600544849474748555555555555555556004455555555555555555555555600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
54555e685e55555555555555555555555e5955557b7b7b7b5556764455557b7b5b7e45555556000054555555555555555566006455555555555555555555555600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
545555794c79555555555555555555555e6955556565557b7b5545555b6b7e7b6b6b7b5b5555454654555555555555555674007664555555737373555555555600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
545555794c79555555555555555555556e55555674766465556b5b5555556565555555655555555555555555555555556674444644555555737363595555555600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
545555794c7955557b555555555555557e556b6b4546767464555b5555667474645556755455555555555555555555567476545555555555716871695555556600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
545555794c79555555555555554d4e4e4d55555b6b5546767454556b55467674445555455555555555555555555555667476545555555548717171484848487600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
545555794c79557b55555555555e59555555555555555b46766455556b554676645555555555555555555555555566747644555555555555555555555555554600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
547b7e794c49494949497070704d7070707055557b7b555545457b7b55555545745555555555555555555555556674444555555555555555555555545555555600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
54557b7b5555557b555571727070707062526955557b7b55557b7b557b555555745555555555556654555555567476645555555555555555556566646565656a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
54555555557b7b7e6a6a6a6a716868717c695555555555655555555555555574555555555565667654555555554600766455555555555664667574747474746000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5455555565557b7b556565557171715259655555555556745455555555557464666455556674744455555556555545454664655555555674747676747574766000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
646565667464656566747564716e526e74746465656566746465656664656674747464667474746465656566646565656674746465656676760000767676006000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
010c000015502155021550215502155021550215502155021550215502155021550215502155021550215502155021b5021b5021b5021a502185021650215502155021550215502155021d552115521155211532
010c000024552185521855218552185521855218552185322450218502185021850224502185021850224502275521b5521b5321b502275521b5521b5321b502265521a552245521855222552165522155215552
010c00002155215552155521555215552155521555215532215021550221502155021d55211552115521d53220552145521453214502205521455214532145022255216552165521653222502165021650216502
010c000021552155521555215552155521555215552155322150215502155021550221502155021d5521155224552185521855218552185521855218552185322450218502185021850224502185021850224502
010c0000275521b5521b5321b502295521d5521d5321d5022b5521f552275521b5522455218552225521655221552155521555215552155521555215552155322150215502155021550221502155021550221502
010c0000205521455214552145321450214502145021450222552165521655216532165021650216502165022455218552225521655221552155521555215532215021550215502155021d552115521155211532
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010c0000136551060310603106033b6550000000000000001065500000106550000010655000000000000000106553b6053b6053b6053b6553b6553b6553b655106550000000000000003b655000003b65500000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00010000000002a03035020390203a02037010280000d000010002900026000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000100001640013600176003d6703d6703e6703d600024000340007400064000d400144001f4002a4003e40011670106700e7700c7700a7700877007770046700367003670036700000000000000000000000000
__music__
00 4142000c
01 4142010c
00 4142020c
00 4142030c
00 4142040c
02 4142050c

