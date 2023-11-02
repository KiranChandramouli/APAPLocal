$PACKAGE APAP.IBS
*-----------------------------------------------------------------------------
* <Rating>100</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE DISP.CTRL.SWIFT(HEADER.REC, OPERAND, CONDITION, RETURN.FLAG)
*---------------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*25/10/2023         Suresh             R22 Manual Conversion                 Nochange
*----------------------------------------------------------------------------------------
    $INSERT I_EQUATE
    $INSERT I_COMMON
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.DE.HEADER

    RETURN.FLAG = 0

    FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER'
    F.FUNDS.TRANSFER = ''
    CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)

    FN.FUNDS.TRANSFER$HIS = 'F.FUNDS.TRANSFER$HIS'
    F.FUNDS.TRANSFER$HIS = ''
    CALL OPF(FN.FUNDS.TRANSFER$HIS,F.FUNDS.TRANSFER$HIS)

    TRANS.REF = HEADER.REC<DE.HDR.TRANS.REF>

    IF TRANS.REF[1,1] = 1 THEN TRANS.REF = TRANS.REF[2,99]

    IF TRANS.REF THEN
        R.FT = ""
        ER = ""
        CALL F.READ(FN.FUNDS.TRANSFER,TRANS.REF,R.FT,F.FUNDS.TRANSFER,ER)
        IF ER THEN
            CALL F.READ.HISTORY(FN.FUNDS.TRANSFER$HIS,TRANS.REF,R.FT, F.FUNDS.TRANSFER$HIS, ER)
        END
        IF R.FT THEN
            TRANS.TYPE = R.FT<FT.TRANSACTION.TYPE>
            IF TRANS.TYPE[1,3] <> CONDITION THEN
                RETURN.FLAG = 1
            END
        END
    END

RETURN
