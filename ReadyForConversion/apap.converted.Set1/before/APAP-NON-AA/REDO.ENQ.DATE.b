*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.ENQ.DATE
*-----------------------------------------------------------------------------
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: JEYACHANDRAN S
* PROGRAM NAME: REDO.ENQ.BUILD.RESTRICT.LIST
* ODR NO      : ODR-2010-08-0470
*----------------------------------------------------------------------
* DESCRIPTION:   This is a Conversion routine attached to the Enquiry
*                REDO.ENQ.CUS.BAD.REFERENCE for getting date
* IN PARAMETER : O.DATA
* OUT PARAMETER: O.DATA
* LINKED WITH  :
*----------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO              REFERENCE         DESCRIPTION
* 18.08.2010  Jeyachandran S        ODR-2010-08-0470  INITIAL CREATION
*----------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.REDO.RESTRICTIVE.LIST

  GOSUB PROCESS
  RETURN
*-------
PROCESS:
*-------

  IF O.DATA THEN
    Y.DATA = O.DATA
    Y.DATE1 = Y.DATA[1,6]
    Y.VAR1 = ICONV(Y.DATE1,"D")
    Y.DD1 = FMT(OCONV(Y.VAR1,"DD"),"R%2")
    Y.MM1 = FMT(OCONV(Y.VAR1,"DM"),"R%2")
    Y.YYYY1 = OCONV(Y.VAR1,"DY4")
    Y.ACT.DATE1 = Y.YYYY1:Y.MM1:Y.DD1

    Y.DATE.2 = FIELD(Y.DATA," ",2)
    Y.DATE2 = Y.DATE.2[1,6]
    Y.VAR2 = ICONV(Y.DATE2,"D")
    Y.DD2 = FMT(OCONV(Y.VAR2,"DD"),"R%2")
    Y.MM2 = FMT(OCONV(Y.VAR2,"DM"),"R%2")
    Y.YYYY2 = OCONV(Y.VAR2,"DY4")
    Y.ACT.DATE2 = Y.YYYY2:Y.MM2:Y.DD2

    Y.ACT.DATE = Y.ACT.DATE1:" ":Y.ACT.DATE2

    O.DATA = Y.ACT.DATE

    RETURN
  END
END
