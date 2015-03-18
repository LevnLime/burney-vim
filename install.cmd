REM ============================================================
REM Parameters
REM ============================================================


REM ============================================================
REM Script Start
REM ============================================================

REM Determine Home directory
@if not exist "%HOME%" @set HOME=%HOMEDRIVE%%HOMEPATH%
@if not exist "%HOME%" @set HOME=%USERPROFILE%

REM Clone the Git repository
@set APP_DIR=%HOME%\.burney-vim
IF NOT EXIST "%APP_DIR%" (
  REM call git clone https://github.com/LevnLime/burney-vim.git "%APP_DIR%"
) ELSE (
	@set ORIGINAL_DIR=%CD%
    echo updating...
    chdir /d "%APP_DIR%" 
REM	call git pull
    chdir /d "%ORIGINAL_DIR%"
	call cd "%APP_DIR%" 
)

REM Create directories
IF NOT EXIST "%APP_DIR%\.vim\bundle" (
	call mkdir "%APP_DIR%\.vim\bundle"
)
IF NOT EXIST "%APP_DIR%\.vim\backup" (
	call mkdir "%APP_DIR%\.vim\backup"
)
IF NOT EXIST "%APP_DIR%\.vim\swap" (
	call mkdir "%APP_DIR%\.vim\swap"
)
IF NOT EXIST "%APP_DIR%\.vim\undo" (
	call mkdir "%APP_DIR%\.vim\undo"
)
IF NOT EXIST "%APP_DIR%\.vim\views" (
	call mkdir "%APP_DIR%\.vim\views"
)

REM Create Links in home folder
REM Note: Apparently making symbolic links require a permission standard
REM users don't have.
REM call mklink "%HOME%\.vimrc" "%APP_DIR%\.vimrc"
REM call mklink "%HOME%\.vimrc.bundles" "%APP_DIR%\.vimrc.bundles"
call mklink /J "%HOME%\.vim" "%APP_DIR%\.vim"

REM Install Vundle
IF NOT EXIST "%HOME%/.vim/bundle/Vundle.vim" (
	call git clone https://github.com/gmarik/Vundle.vim.git "%HOME%/.vim/bundle/Vundle.vim"
) ELSE (
  call cd "%HOME%/.vim/bundle/Vundle.vim"
  call git pull
  call cd %HOME%
)

REM Install/update all bundles
call vim -u "%APP_DIR%/.vimrc.bundles" +PluginInstall! +PluginClean +qall
