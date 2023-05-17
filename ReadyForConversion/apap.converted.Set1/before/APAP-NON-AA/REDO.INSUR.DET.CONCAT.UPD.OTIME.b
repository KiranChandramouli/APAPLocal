*-----------------------------------------------------------------------------
* <Rating>-21</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.INSUR.DET.CONCAT.UPD.OTIME
*------------------------------------------------------------------------
* Description: This is a one time routine to link the AA loan with Insurance details in concat file.
*              This should be run daily in the testing environment as System date and bank date will be different
*------------------------------------------------------------------------
* Modification History
*-----------------------------------------------------------------------------------------------------------------
* Modification History :
* ----------------------
*   Date          Author              Modification Description
* 27-03-2015     V.P.Ashokkumar        PACS00313072- Initial Release
*------------------------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.APAP.H.INSURANCE.DETAILS

  GOSUB INIT
  GOSUB PROCESS
  RETURN

INIT:
*----
  FN.APAP.H.INSURANCE.DETAILS = 'F.APAP.H.INSURANCE.DETAILS'
  F.APAP.H.INSURANCE.DETAILS = ''
  CALL OPF(FN.APAP.H.INSURANCE.DETAILS,F.APAP.H.INSURANCE.DETAILS)

  FN.APAP.H.INSURANCE.ID.CONCAT = 'F.APAP.H.INSURANCE.ID.CONCAT'
  F.APAP.H.INSURANCE.ID.CONCAT = ''
  CALL OPF(FN.APAP.H.INSURANCE.ID.CONCAT,F.APAP.H.INSURANCE.ID.CONCAT)
  RETURN

PROCESS:
*-------
  SEL.LIST = ''; SEL.NOR = ''; SEL.RET = ''; SEL.CMD = ''
  SEL.CMD = 'SSELECT ':FN.APAP.H.INSURANCE.DETAILS:' BY ASSOCIATED.LOAN'
  CALL EB.READLIST(SEL.CMD,SEL.LIST,'',SEL.NOR,SEL.RET)

  LOOP
    REMOVE SEL.ID FROM SEL.LIST SETTING SEL.POSN
  WHILE SEL.ID:SEL.POSN
    APAP.H.INSURANCE.DETAILS.ERR = ''; R.APAP.H.INSURANCE.DETAILS = ''; YINS.TYPE = ''; INS.AMT = ''; AA.LOAN.ID = ''
    CALL F.READ(FN.APAP.H.INSURANCE.DETAILS,SEL.ID,R.APAP.H.INSURANCE.DETAILS,F.APAP.H.INSURANCE.DETAILS,APAP.H.INSURANCE.DETAILS.ERR)
    YINS.TYPE = R.APAP.H.INSURANCE.DETAILS<INS.DET.INS.POLICY.TYPE>
    INS.AMT = R.APAP.H.INSURANCE.DETAILS<INS.DET.INS.AMOUNT>
    AA.LOAN.ID = R.APAP.H.INSURANCE.DETAILS<INS.DET.ASSOCIATED.LOAN>

    ERR.AHIIC = ''; R.APAP.H.INSURANCE.ID.CONCAT = ''; CONCAT.INS.TYPE = ''; CONCAT.INS.AMT = ''; CONCAT.INS.ID = ''
    CALL F.READ(FN.APAP.H.INSURANCE.ID.CONCAT,AA.LOAN.ID,R.APAP.H.INSURANCE.ID.CONCAT,F.APAP.H.INSURANCE.ID.CONCAT,ERR.AHIIC)
    IF R.APAP.H.INSURANCE.ID.CONCAT THEN
      CONCAT.INS.ID = R.APAP.H.INSURANCE.ID.CONCAT<1>
      CONCAT.INS.TYPE = R.APAP.H.INSURANCE.ID.CONCAT<2>
      CONCAT.INS.AMT = R.APAP.H.INSURANCE.ID.CONCAT<3>
      FINDSTR SEL.ID IN CONCAT.INS.ID SETTING IT.POSN,ITS.POSN,ITV.POSN THEN
        CONCAT.INS.AMT<IT.POSN> = INS.AMT
      END ELSE
        R.APAP.H.INSURANCE.ID.CONCAT<1,-1> = SEL.ID
        R.APAP.H.INSURANCE.ID.CONCAT<2,-1> = YINS.TYPE
        R.APAP.H.INSURANCE.ID.CONCAT<3,-1> = INS.AMT
      END
    END ELSE
      R.APAP.H.INSURANCE.ID.CONCAT<1> = SEL.ID
      R.APAP.H.INSURANCE.ID.CONCAT<2> = YINS.TYPE
      R.APAP.H.INSURANCE.ID.CONCAT<3> = INS.AMT
    END
*    WRITE R.APAP.H.INSURANCE.ID.CONCAT TO F.APAP.H.INSURANCE.ID.CONCAT,AA.LOAN.ID ON ERROR NULL ;*Tus Start 
CALL F.WRITE(FN.APAP.H.INSURANCE.ID.CONCAT,AA.LOAN.ID,R.APAP.H.INSURANCE.ID.CONCAT) ; * Tus End
  REPEAT
  RETURN
END
