* @ValidationCode : MjotMTk4MTc1MDcwMjpDcDEyNTI6MTcwMzI1MTcyNDYwMjp2aWduZXNod2FyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 22 Dec 2023 18:58:44
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : vigneshwari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.AA ;*R22 Manual Code Conversion
SUBROUTINE REDO.AA.ACCOUNT.CLOSE.PHANTOM
*--------------------------------------------------------------
*Description: This routine is to remove the arrangement id field for AA Account.
*             And it is attached to EB.PHANTOM>REDO.AA.ACCOUNT.CLOSE
*             PACS00470074
*--------------------------------------------------------------

*-----------------------------------------------------------------------------------

* Modification History:
* Date                  Who                               Reference           Description
* ----                  ----                                ----                 ----
* 29-March-2023          Ajith Kumar         R22 Manual Code Conversion      Package Name added APAP.AA
* 29-March-2023       Conversion Tool                     R22 Auto Code Conversion             Nochange
*21-12-2023                 VIGNESHWARI      MANUAL R22 CODE CONVERSION                 CALL RTN MODIFIED
*-----------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.EB.PHANTOM
    $USING EB.TransactionControl

    GOSUB OPEN.FILES
    GOSUB PROCESS
 

    TEXT    = ERR.MSG:" - &"
    TEXT<2> = Y.AA.ACC.ID
    CALL OVE


RETURN
*--------------------------------------------------------------
OPEN.FILES:
*--------------------------------------------------------------
    ERR.MSG = ""

    FN.ACCOUNT = "F.ACCOUNT"
    F.ACCOUNT  = ""
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

RETURN
*--------------------------------------------------------------
PROCESS:
*--------------------------------------------------------------


    Y.AA.ACC.ID = R.NEW(TD.DESCRIPTION)<1,1>
    CALL F.READ(FN.ACCOUNT,Y.AA.ACC.ID,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
    IF R.ACCOUNT EQ "" THEN
        ERR.MSG = "ERROR - ACCOUNT RECORD NOT EXIST"
        RETURN
    END
    IF R.ACCOUNT<AC.ARRANGEMENT.ID> THEN
        R.ACCOUNT<AC.ARRANGEMENT.ID> = ""
        TEMP.V = V
        V = AC.AUDIT.DATE.TIME
        CALL F.LIVE.WRITE(FN.ACCOUNT,Y.AA.ACC.ID,R.ACCOUNT)
        V = TEMP.V
       * CALL JOURNAL.UPDATE("")
       EB.TransactionControl.JournalUpdate("");*R22 MANUAL CODE CONVERSION-CALL RTN MODIFIED
        ERR.MSG = "Updated Successfully"
    END ELSE
        ERR.MSG = "ERROR - ARRANGEMENT ID ALREADY REMOVED"
    END

RETURN
END
