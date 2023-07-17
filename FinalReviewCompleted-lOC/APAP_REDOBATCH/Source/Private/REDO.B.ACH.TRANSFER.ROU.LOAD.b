* @ValidationCode : MjoxODI5MTM5Nzc5OkNwMTI1MjoxNjgxMTExODkwODA0OklUU1M6LTE6LTE6MTg1OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 10 Apr 2023 13:01:30
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 185
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.ACH.TRANSFER.ROU.LOAD
*-----------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : TAM
* Program Name  : REDO.B.ACH.TRANSFER.ROU.LOAD
* ODR NUMBER    : PACS0006290 - ODR-2011-01-0492
*--------------------------------------------------------------------------------------
* Description   : This routine will run while daily cob and create FT records.
* In parameter  : Y.ID
* out parameter : none
*--------------------------------------------------------------------------------------
* Modification History :
*--------------------------------------------------------------------------------------
*   DATE             WHO             REFERENCE                      DESCRIPTION
* 01-06-2011      MARIMUTHU s     ODR-2011-01-0492 (PACS0006290)    Initial Creation
* 04-APR-2023     Conversion tool   R22 Auto conversion            FM TO @FM, VM to @VM
* 04-APR-2023      Harishvikram C   Manual R22 conversion          No changes
*--------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.ACH.TRANSFER.ROU.COMMON
    $INSERT I_F.REDO.H.PAY.MODE.PARAM

MAIN:

    GOSUB OPENFILES
    GOSUB PGM.END

OPENFILES:

    FN.REDO.ACH.TRANSFER.DETAILS = 'F.REDO.ACH.TRANSFER.DETAILS'
    F.REDO.ACH.TRANSFER.DETAILS = ''
    CALL OPF(FN.REDO.ACH.TRANSFER.DETAILS,F.REDO.ACH.TRANSFER.DETAILS)

    FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER'
    F.FUNDS.TRANSFER = ''
    CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)

    FN.REDO.H.PAY.MODE.PARAM = 'F.REDO.H.PAY.MODE.PARAM'
    F.REDO.H.PAY.MODE.PARAM = ''

    CALL CACHE.READ(FN.REDO.H.PAY.MODE.PARAM,'SYSTEM',R.REDO.H.PAY.MODE.PARAM,F.REDO.H.PAY.MODE.PARAM)
    Y.PAYMNT.MODE = R.REDO.H.PAY.MODE.PARAM<REDO.H.PAY.PAYMENT.MODE>
    Y.PAYMNT.MODE = CHANGE(Y.PAYMNT.MODE,@VM,@FM)
    LOCATE 'Transfer.via.ACH' IN Y.PAYMNT.MODE SETTING POS THEN
        Y.DEB.ACCT.NO = R.REDO.H.PAY.MODE.PARAM<REDO.H.PAY.ACCOUNT.NO,POS>
    END
    APPNS = 'FUNDS.TRANSFER'
    LOC.FIELDS = 'L.FT.ACH.B.NAM':@VM:'L.FT.ACH.B.ACC':@VM:'L.FTST.ACH.PART'
    CALL MULTI.GET.LOC.REF(APPNS,LOC.FIELDS,POS.LC)
    Y.POS.BEN = POS.LC<1,1>
    Y.POS.BEN.AC = POS.LC<1,2>
    Y.POS.BEN.ACH = POS.LC<1,3>

RETURN

PGM.END:

END
