@license{
  Copyright (c) Tijs van der Storm <Centrum Wiskunde & Informatica>.
  All rights reserved.
  This file is licensed under the BSD 2-Clause License, which accompanies this project
  and is available under https://opensource.org/licenses/BSD-2-Clause.
}
@contributor{Tijs van der Storm - storm@cwi.nl - CWI}

module salix::demo::basic::Clock

import salix::SVG;
import salix::HTML;
import salix::App;
import salix::Core;
import util::Math;
import IO;

alias Model = tuple[int time, bool running];

Model init() = <1, false>;

void() compose(list[tuple[void(list[value] vals) call, list[value] args]] t) {
     return () {
             for (d<-t) {
                d.call(d.args
                );
                }
             };          
     }
            
void() fn(Model m)  = {
      real angle = 2 * PI() * (toReal(m.time) / 60.0);
      int handX = round(50 + 40 * cos(angle));
      int handY = round(50 + 40 * sin(angle));
      return compose([<svg, [viewBox("0 0 100 100"), width("300px"),
        compose([
          <circle, [cx("50"), cy("50"), r("45"), fill("#0B79CE")]>
          ,
          <line, [x1("50"), y1("50"), x2("<handX>"), y2("<handY>"), stroke("#023963")]>]
         )]>]);
      };

data Msg
  = tick(int time)
  | toggle(str lab)
  ;

list[Sub] subs(Model m) = [timeEvery(tick, 1000) | m.running ];

Model update(Msg msg, Model t) {
  switch (msg) {
   case tick(int time): t.time = time;
   case toggle(str q): t.running = !t.running;
  }
  return t;
}

App[Model] clockApp() = 
  app(init, view, update, 
    |http://localhost:9102|, |project://mondriaan/src|,
    subs = subs); 


void view(Model m) {
  div(() {
    h2("Clock using SVG");
    clock(m);
  });
}

void clock(Model m) {
  real angle = 2 * PI() * (toReal(m.time) / 60.0);
  int handX = round(50 + 40 * cos(angle));
  int handY = round(50 + 40 * sin(angle));
  fn(m)();
  //svg(viewBox("0 0 100 100"), width("300px"), () {
  //  circle(cx("50"), cy("50"), r("45"), fill("#0B79CE"));
  //  line(x1("50"), y1("50"), x2("<handX>"), y2("<handY>"), stroke("#023963"));
  //}); 
  button(onClick(toggle("aap")), "On/Off");
}

public App[Model] c = clockApp();




