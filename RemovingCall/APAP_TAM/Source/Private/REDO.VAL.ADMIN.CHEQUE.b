* @ValidationCode : MjotMTg4NzA5Njk3MzpDcDEyNTI6MTY4MzAyNDMzNTE0OTpJVFNTOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 02 May 2023 16:15:35
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
*-----------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*18/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION          FM TO @FM, VM TO @VM
*18/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*-----------------------------------------------------------------------------------
SUBROUTINE REDO.VAL.ADMIN.CHEQUE
*------------------------------------------------------
*Description: This is the validation routine for field cheque no. to validate whether
* cheque is already paid or not.
*------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.APAP.CLEARING.INWARD
    $INSERT I_F.REDO.ADMIN.CHQ.PARAM
    $INSERT I_F.REDO.ADMIN.CHQ.DETAILS
    $INSERT I_F.CERTIFIED.CHEQUE.PARAMETER
    $INSERT I_F.CERTIFIED.CHEQUE.DETAILS
 
    GOSUB PROCESS
RETURN
*------------------------------------------------------
PROCESS:
*------------------------------------------------------

    Y.STATUS = R.NEW(CLEAR.CHQ.STATUS)
    IF Y.STATUS EQ 'PAID' THEN
        GOSUB ADMIN.CHECK
    END
RETURN
 
*--------------------------------------------------------------
ADMIN.CHECK:
*--------------------------------------------------------------

    FN.REDO.ADMIN.CHQ.PARAM = 'F.REDO.ADMIN.CHQ.PARAM'
    F.REDO.ADMIN.CHQ.PARAM = ''
    CALL OPF(FN.REDO.ADMIN.CHQ.PARAM,F.REDO.ADMIN.CHQ.PARAM)

    FN.REDO.ADMIN.CHQ.DETAILS = 'F.REDO.ADMIN.CHQ.DETAILS'
    F.REDO.ADMIN.CHQ.DETAILS = ''
    CALL OPF(FN.REDO.ADMIN.CHQ.DETAILS,F.REDO.ADMIN.CHQ.DETAILS)


    Y.CHEQUE.ACCOUNT   = R.NEW(CLEAR.CHQ.ACCOUNT.NO)
    Y.CHEQUE.NO        = TRIM(COMI,"0", "L")
    CALL CACHE.READ(FN.REDO.ADMIN.CHQ.PARAM,'SYSTEM',R.REDO.ADMIN.CHQ.PARAM,ADM.CHQ.ERR)
    Y.ADMIN.ACCTS = R.REDO.ADMIN.CHQ.PARAM<ADMIN.CHQ.PARAM.ACCOUNT>
    CHANGE @VM TO @FM IN Y.ADMIN.ACCTS
    LOCATE Y.CHEQUE.ACCOUNT IN Y.ADMIN.ACCTS SETTING POS1 THEN
        CALL F.READ(FN.REDO.ADMIN.CHQ.DETAILS,Y.CHEQUE.NO,R.REDO.ADMIN.CHQ.DETAILS,F.REDO.ADMIN.CHQ.DETAILS,CHQ.DET.ERR)
        Y.CHEQUE.STATUS = R.REDO.ADMIN.CHQ.DETAILS<ADMIN.CHQ.DET.STATUS>
        IF Y.CHEQUE.STATUS NE 'ISSUED' THEN

            ETEXT = 'EB-REDO.ADMIN.CHQ.ALREADY.PAID'
            CALL STORE.END.ERROR
        END
        RETURN          ;* Since its a admin cheque no need to process for manager cheque
    END

    FN.CERTIFIED.CHEQUE.PARAMETER = 'F.CERTIFIED.CHEQUE.PARAMETER'
    F.CERTIFIED.CHEQUE.PARAMETER = ''
    CALL OPF(FN.CERTIFIED.CHEQUE.PARAMETER,F.CERTIFIED.CHEQUE.PARAMETER)

    FN.CERTIFIED.CHEQUE.DETAILS = 'F.CERTIFIED.CHEQUE.DETAILS'
    F.CERTIFIED.CHEQUE.DETAILS  = ''
    CALL OPF(FN.CERTIFIED.CHEQUE.DETAILS,F.CERTIFIED.CHEQUE.DETAILS)

    Y.ID.COMPANY = ID.COMPANY
    CALL CACHE.READ(FN.CERTIFIED.CHEQUE.PARAMETER,Y.ID.COMPANY,R.CERTIFIED.CHEQUE.PARAMETER,CER.CGQ.ERR)
    Y.CERT.ACCOUNTS = R.CERTIFIED.CHEQUE.PARAMETER<CERT.CHEQ.ACCOUNT.NO>
    CHANGE @VM TO @FM IN Y.CERT.ACCOUNTS
    LOCATE Y.CHEQUE.ACCOUNT IN Y.CERT.ACCOUNTS SETTING CER.ACT.POS THEN
        CALL F.READ(FN.CERTIFIED.CHEQUE.DETAILS,Y.CHEQUE.NO,R.CERTIFIED.CHEQUE.DETAILS,F.CERTIFIED.CHEQUE.DETAILS,CERTIFIED.CHEQUE.DETAILS.ERR)
        CER.STATUS = R.CERTIFIED.CHEQUE.DETAILS<CERT.DET.STATUS>
        IF CER.STATUS NE 'ISSUED' THEN

            ETEXT = 'EB-REDO.ADMIN.CHQ.ALREADY.PAID'
            CALL STORE.END.ERROR
        END
    END
RETURN

END
