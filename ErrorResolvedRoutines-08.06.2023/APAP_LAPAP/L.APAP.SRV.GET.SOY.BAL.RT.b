* @ValidationCode : MjotMTMxNDQ3NTc5MTpDcDEyNTI6MTY4NjEzMzY4MDk4MDpoYWk6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 07 Jun 2023 15:58:00
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : hai
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.SRV.GET.SOY.BAL.RT
*----------------------------------------------------------------------------
* Modification History :
* ----------------------
*   Date       Author                  Modification Description
* 06-06-2023   Ghayathri T             R22 Manual Conversion - Commended the CLOSESEQ FV.PRT line
* 24-05-2023   Conversion Tool         R22 Auto Conversion - Removed T24.BP in insert
*----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT

    GOSUB INI
    GOSUB GET_LIST

INI:
    Y.DIR.NAME.FINAL='../interface/ASAMBLEA'
    Y.FILE.NAME.FINAL='SOY.ACCT.BAL.csv'
    FN.AC = "F.ACCOUNT"
    F.AC = ""
    FV.ACC = ""
    R.ACC = ""
    ACC.ERR = ""
    CALL OPF(FN.AC,F.AC)

    OPENSEQ Y.DIR.NAME.FINAL,Y.FILE.NAME.FINAL TO FV.PTR.FIN ELSE
        CREATE FV.PTR.FIN ELSE
            PRINT @(12,12): "CANNOT OPEN DIR ": Y.DIR.NAME.FINAL
            STOP
        END
    END
RETURN

GET_LIST:
    SEL.CMD = "SELECT " : FN.AC : " WITH CATEGORY GE 6000 AND CATEGORY LE 6599 AND CATEGORY NE 6013 AND CATEGORY NE 6014 AND CATEGORY NE 6015 AND CATEGORY NE 6016 AND CATEGORY NE 6017 AND CATEGORY NE 6018 AND CATEGORY NE 6019 AND CATEGORY NE 6020"
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.RECS,SEL.ERR)
    LOOP REMOVE Y.ACCT.ID FROM SEL.LIST SETTING STMT.POS

    WHILE Y.ACCT.ID DO
        GOSUB GET_SET_ACCT_INFO

    REPEAT

RETURN

GET_SET_ACCT_INFO:
    CALL F.READ(FN.AC, Y.ACCT.ID, R.ACC, F.AC, '')
    IF R.ACC NE '' THEN
        Y.ID = Y.ACCT.ID
        Y.START.YEAR.BAL = R.ACC<AC.START.YEAR.BAL>
        Y.CAT = R.ACC<AC.CATEGORY>
        Y.FINAL = Y.ID : "," : Y.START.YEAR.BAL : "," : Y.CAT : ","
        WRITESEQ Y.FINAL TO FV.PTR.FIN ELSE
            PRINT @(12,12): "NO SE PUDO ESCRIBIR EN EL ARCHIVO"
        END
    END
RETURN

*CLOSESEQ FV.PRT;* R22 Manual Conversion commended the CLOSESEQ FV.PRT line
CLOSESEQ FV.PTR.FIN
PRINT @(12,12): "ARCHIVO GENERADO."

END
