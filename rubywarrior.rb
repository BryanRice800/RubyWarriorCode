class Player
  def play_turn(warrior)
    # cool code goes here
    @minimumHealth = 10
    if @warriorNeedsRest != nil and @warriorNeedsRest == true then
      if warrior.health < @previousHealth then
        if @walkingForward == nil then
          warrior.walk!
        else
          warrior.walk!(:backward)
        end
      elsif warrior.health >= 20 then
        @warriorNeedsRest = false
        if @walkingForward == nil then
          warrior.walk!
        else
          warrior.walk!(:backward)
        end
      else
        warrior.rest!
      end
    elsif @walkingForward == nil or @walkingForward == false then
      @enemiesBehind = false;
      warrior.look(:backward).each { |spot|
        if spot.captive? then
          #do nothing
          break
        elsif spot.enemy? then
          @enemiesBehind = true
          break
        end
      }
      if @enemiesAhead == true then
        warrior.shoot!(:backward)
      elsif warrior.feel(:backward).captive? then
        warrior.rescue!(:backward)
      elsif warrior.feel(:backward).enemy? then
        if warrior.health > 5 then
          warrior.attack!(:backward)
        else
          warrior.walk!
          @warriorNeedsRest = true
        end
      elsif warrior.feel(:backward).empty? then
                #are we taking damage?
        if @previousHealth == nil then
          warrior.walk!(:backward)
        elsif warrior.health < @previousHealth then
          #do we have enough hp?
          if warrior.health < @minimumHealth then
            #go back
            warrior.walk!
            @warriorNeedsRest = true
          else
            #charge!!!
            warrior.walk!(:backward)
          end
        else
          if warrior.health < @minimumHealth then
            #go back
            warrior.walk!
            @warriorNeedsRest = true
          else
            warrior.walk!(:backward)
          end
        end
      elsif warrior.feel(:backward).wall? then
        warrior.walk!
         @walkingForward = 'yes'
      end
    else
      @enemiesAhead = false
      warrior.look.each do |spot|
        if spot.captive? then
          #do nothing
          break
        elsif spot.enemy? then
          @enemiesAhead = true
          break
        end
      end
      if @enemiesAhead == true then
        warrior.shoot!
      elsif warrior.feel.captive? then
        warrior.rescue!
      elsif warrior.feel.enemy? then
        if warrior.health > 3 then
          warrior.attack!
        else
          warrior.walk!(:backward)
          @warriorNeedsRest = true
        end
      elsif warrior.feel.empty? then
        #are we taking damage?
        if warrior.health < @previousHealth then
          #do we have enough hp?
          if warrior.health < @minimumHealth then
            #go back
            warrior.walk!(:backward)
            @warriorNeedsRest = true
          else
            #charge!!!
            warrior.walk!
          end
        else
          if warrior.health < @minimumHealth then
            #go back
            warrior.walk!(:backward)
            @warriorNeedsRest = true
          else
            warrior.walk!
          end
        end
      end
    end

    if warrior.health < 5 then
      @warriorNeedsRest = true
    end
    @previousHealth = warrior.health
  end
end
