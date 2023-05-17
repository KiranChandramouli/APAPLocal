*-----------------------------------------------------------------------------
* <Rating>-21</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.CHK.TELLER.ID1
*---------------------------------------------------------------------------------------
*DESCRIPTION: This routine will default the teller id for the from teller attach to the
*version of TELLER,REDO.TILL.TRNS
*---------------------------------------------------------------------------------------
*IN  :  -NA-
*OUT :  -NA-
*****************************************************
*COMPANY NAME : APAP
*DEVELOPED BY : DHAMU S
*PROGRAM NAME : REDO.V.CHK.TELLER.ID
*----------------------------------------------------------------------------------------------
*Modification History:
*------------------------
*DATE               WHO              REFERENCE                    DESCRIPTION
*9-6-2011        S.DHAMU           ODR-2009-10-0525             INITIAL CREATION
*-----------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.TELLER
$INSERT I_F.TELLER.ID

  GOSUB INIT
  GOSUB PROCESS
  RETURN
******
INIT:
******

  FN.TELLER = 'F.TELLER'
  F.TELLER  = ''
  CALL OPF(FN.TELLER,F.TELLER)

  FN.TELLER.ID = 'F.TELLER.ID'
  F.TELLER.ID  = ''
  CALL OPF(FN.TELLER.ID,F.TELLER.ID)
  RETURN
********
PROCESS:
********
  Y.REC.STATUS=R.NEW(TT.TE.RECORD.STATUS)
  IF Y.REC.STATUS EQ 'INA2' OR Y.REC.STATUS EQ 'INAU' THEN
    RETURN
  END ELSE
    SEL.CMD ="SELECT ":FN.TELLER.ID:" WITH STATUS EQ OPEN AND USER EQ ":OPERATOR
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,REC.ERR)
    Y.TELLER.ID = SEL.LIST<1>
    R.NEW(TT.TE.TELLER.ID.1) = Y.TELLER.ID
  END
  RETURN
***************************************************************
END
*-----------------End of program--------------------------------------------------
