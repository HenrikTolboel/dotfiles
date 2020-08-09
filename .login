#echo ".login"


# fra /net/lchlx/usr/acct/lch/InitialEnvs
if ($?OPSYS) then
   if ("$OPSYS" == "MACOSX" || "$OPSYS" == "LINUX") then
         #setenv   CCS $HOME/ccs/
         #On the Mac the compiled-in fall-back for $VIM: is "/usr/share/vim"
         #On Linux the system vimrc is /etc/vimc, so it needs to be modified
         #to source $VIM/vimrc
         setenv VIM /usr/local2/share/vim
   endif
endif

set path = ($path /Users/henrik/local/bin)
setenv LESS smeqFXR

setenv JAVA_HOME `/usr/libexec/java_home`

setenv SOURCE /Users/henrik/Documents

#echo ".login end"
