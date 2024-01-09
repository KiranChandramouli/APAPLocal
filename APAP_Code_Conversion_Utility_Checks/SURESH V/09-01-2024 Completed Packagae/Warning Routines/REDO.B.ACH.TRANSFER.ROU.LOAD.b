* @ValidationCode : MjoxNTkyNTk3NjMwOkNwMTI1MjoxNzAzMTM0NTQwMzA1OjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIyX1NQNS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 21 Dec 2023 10:25:40
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
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
*20/12/2023         Suresh             R22 Manual Conversion       IDVAR Variable changed
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
    
    IDVAR='SYSTEM' ;*R22 Manual Conversion
    CALL CACHE.READ(FN.REDO.H.PAY.MODE.PARAM,IDVAR,R.REDO.H.PAY.MODE.PARAM,F.REDO.H.PAY.MODE.PARAM) ;*R22 Manual Conversion
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
