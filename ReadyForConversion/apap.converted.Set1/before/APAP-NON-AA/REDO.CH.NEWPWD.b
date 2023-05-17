*-----------------------------------------------------------------------------
* <Rating>-13</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.CH.NEWPWD
**
* Subroutine Type : VERSION
* Attached to     : PASSWORD.RESET,REDO.CH.RESUSRPWD
* Attached as     : USER.PASSWORD field as AUTO.NEW.CONTENT
* Primary Purpose : Generate a new temporal password for Internet User.
*-----------------------------------------------------------------------------
* MODIFICATIONS HISTORY
*
* 1/11/10 - First Version.
*           ODR Reference: ODR-2010-06-0155.
*           Project: NCD Asociacion Popular de Ahorros y Prestamos (APAP).
*           Martin Macias.
*           mmacias@temenos.com
* 07/11/11 - Fix for PACS00146411.
*            Roberto Mondragon - TAM Latin America.
*            rmondragon@temenos.com
*-----------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_System

$INSERT I_F.PASSWORD.RESET
$INSERT I_REDO.CH.NEWPWD.COMMON

  GOSUB CREATE.PWD

  RETURN

***********
CREATE.PWD:
***********

  PWD = ""
  RANDOMIZE (TIME())
  FOR x = 1 TO 8
    CharType = RND(3)         ;* Determines whether an uppercase, lowercase or number will be generated next
    BEGIN CASE
    CASE CharType = 0; PWD:= CHAR(RND(26) + 65)   ;* Uppercase char
    CASE CharType = 1; PWD:= CHAR(RND(26) + 97)   ;* Lowercase char
    CASE CharType = 2; PWD:= RND(10)
    END CASE
  NEXT x

  PASS = PWD
  R.NEW(EB.PWR.USER.PASSWORD) = PWD
  CALL System.setVariable('CURRENT.ARC.PASS',PWD)

  RETURN

END

