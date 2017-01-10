source shpec-helper.bash
initialize_shpec_helper

shpec_source lib/import.bash

eval "$(importa kzn '( defa defs geta stripa )')"

describe 'importa'
  it "prints a function by array of names from a sourcefile"; (
    defs expected <<'EOS'
      _imp_test () 
      { 
          :
      }
      imports () 
      { 
          ( eval "$(passed '( sourcefile function )' "$@")";
          importa sourcefile '( '"$function"' )' )
      }
EOS
    assert equal "$expected" "$(importa import '( imports )')"
    return "$_shpec_failures" )
  end
end

describe 'imports'
  it "prints a function by name from a sourcefile, including required imports"; (
    defs expected <<'EOS'
      _imp_test () 
      { 
          :
      }
      imports () 
      { 
          ( eval "$(passed '( sourcefile function )' "$@")";
          importa sourcefile '( '"$function"' )' )
      }
EOS
    assert equal "$expected" "$(imports import imports)"
    return "$_shpec_failures" )
  end
end

describe 'print_function'
  it "prints a function's definition"; (
    samplef() { :;}
    defs expected <<'EOS'
      samplef () 
      { 
          :
      }
EOS
    assert equal "$expected" "$(print_function samplef)"
    return "$_shpec_failures" )
  end
end
