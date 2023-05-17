*-----------------------------------------------------------------------------
* <Rating>-21</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.TELLER.PROCESS.RECORD
*-----------------------------------------------------------------------------
*----------------------------------------------------------------------------------------
* DESCRIPTION :  This is routine is needed to automatically populate
* the field BRANCH.CODE in the template REDO.TELLER.PROCESS
*----------------------------------------------------------------------------------------
*----------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*----------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : SUDHARSANAN S
* PROGRAM NAME : REDO.TELLER.PROCESS.RECORD
*----------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO                REFERENCE         DESCRIPTION
* 13.05.2010      SUDHARSANAN S     ODR-2009-10-0322  INITIAL CREATION
* ---------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_GTS.COMMON
$INSERT I_F.REDO.TELLER.PROCESS
$INSERT I_F.REDO.USER.ACCESS
  GOSUB INIT
  GOSUB PROCESS
  RETURN
*-----------------------------------------------------------------------------
INIT:
  FN.REDO.USER.ACCESS = 'F.REDO.USER.ACCESS'
  F.REDO.USER.ACCESS = ''
  CALL OPF(FN.REDO.USER.ACCESS,F.REDO.USER.ACCESS)
  RETURN
*----------------------------------------------------------------------------
PROCESS:
*Update branch code field  in the REDO.TELLER.PROCESS table

  IF V$FUNCTION = "I" AND PGM.VERSION EQ ",PROCESS" THEN
*T(TEL.PRO.BRANCH.DES)<3> = 'NOINPUT'
  END
  RETURN
*--------------------------------------------------------------------------
END
