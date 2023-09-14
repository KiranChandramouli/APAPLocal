$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.GET.MOTIVO.RECHAZO.ACH.RT
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 21-APRIL-2023      Conversion Tool       R22 Auto Conversion - FM to @FM , I to I.VAR , Include to Insert and T24.BP is removed from Insert
* 21-APRIL-2023      Harsha                R22 Manual Conversion - No changes                             
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.REDO.ACH.PROCESS.DET

    Y.RESULT = ''
    Y.NUM.TXN = COMI

    IF SUBSTRINGS(Y.NUM.TXN, 1, 2) EQ 'FT' THEN
        GOSUB INITIALISE
        GOSUB GET.MOTIVO.ACH
    END

    COMI = Y.RESULT

RETURN

*----------
INITIALISE:
*----------
    FN.REDO.ACH.PROCESS.DET = "F.REDO.ACH.PROCESS.DET"; F.REDO.ACH.PROCESS.DET = ""
    CALL OPF(FN.REDO.ACH.PROCESS.DET, F.REDO.ACH.PROCESS.DET)

RETURN
*---------------
GET.MOTIVO.ACH:
*---------------

    SEL.LIST = ""; NO.REC = ""; ERR = ""
    SEL.CMD = "SELECT ":FN.REDO.ACH.PROCESS.DET : " WITH T24.TXN.ID EQ " : Y.NUM.TXN
    CALL EB.READLIST(SEL.CMD, SEL.LIST, "", NO.REC, ERR)

    FOR I.VAR = 1 TO NO.REC
        R.ACH.DET = ""
        READ R.ACH.DET FROM F.REDO.ACH.PROCESS.DET, SEL.LIST<I.VAR> THEN
            Y.MOTIVO = FIELD(R.ACH.DET,@FM,8)

            IF Y.MOTIVO THEN
                Y.RESULT = SUBSTRINGS(Y.MOTIVO, 34, 200)
            END

            RETURN
        END
    NEXT I.VAR

RETURN

END
