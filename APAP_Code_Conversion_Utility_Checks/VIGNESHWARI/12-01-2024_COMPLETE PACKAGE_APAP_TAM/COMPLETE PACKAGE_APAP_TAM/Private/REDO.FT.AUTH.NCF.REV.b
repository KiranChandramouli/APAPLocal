* @ValidationCode : MjotODMxNTk1NzcxOkNwMTI1MjoxNzA0OTY5NjQ0MjcxOnZpZ25lc2h3YXJpOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 11 Jan 2024 16:10:44
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
$PACKAGE APAP.TAM
SUBROUTINE REDO.FT.AUTH.NCF.REV
    
****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : GANESH R
* Program Name  : REDO.AUTH.NCF.REV.UPD
* ODR NUMBER    : ODR-2009-10-0321
*-------------------------------------------------------------------------
* Description : This Auth routine is triggered when FT,TT,MM,FX,DC,DD transaction is Authorised
* In parameter : None
* out parameter : None
*-----------------------------------------------------------------------------
*Modification history:
*--------------------------------------------------------------------------
*   Date               who           Reference            Description
* 10-AUG-2010        Prabhu.N         HD1026443     @ID modified for REDO.NCF.ISSUED table

* Date             Who                   Reference      Description
* 05.04.2023       Conversion Tool       R22            Auto Conversion     - VM TO @VM
* 05.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
*
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.TRANSACTION
    $INSERT I_F.REDO.L.NCF.STATUS
    $INSERT I_F.REDO.L.NCF.CANCELLED
    $INSERT I_F.REDO.NCF.ISSUED
    GOSUB INIT
    GOSUB OPEN.FILES
    GOSUB PROCESS
RETURN

*****
INIT:
******
*Initialisation

    VAR.TXN.ID=''
    LRF.APP='FUNDS.TRANSFER'
    LRF.FIELD='L.NCF.NUMBER':@VM:'L.NCF.TAX.NUM':@VM:'TRANSACTION.REF'
    LRF.POS=''
*
    CALL MULTI.GET.LOC.REF(LRF.APP,LRF.FIELD,LRF.POS)
    POS.FT.NCF.NUM=LRF.POS<1,1>
    POS.FT.NCF.TAX.NUM=LRF.POS<1,2>
    POS.FT.TXN.REF=LRF.POS<1,3>
*
    FN.REDO.NCF.ISSUED='F.REDO.NCF.ISSUED'
    F.REDO.NCF.ISSUED=''
*
    FN.REDO.NCF.STATUS='F.REDO.L.NCF.STATUS'
    F.REDO.NCF.STATUS=''
*
    FN.TRANSACTION='F.TRANSACTION'
    F.TRANSACTION=''
*
    FN.REDO.L.NCF.CANCELLED='F.REDO.L.NCF.CANCELLED'
    F.REDO.L.NCF.CANCELLED=''
*
    FN.FT = 'F.FUNDS.TRANSFER'
    F.FT = ''

    FN.FT.HIS = 'F.FUNDS.TRANSFER$HIS'
    F.FT.HIS = ''

RETURN
*
**********
OPEN.FILES:
***********
*Opening the Files
    CALL OPF(FN.REDO.NCF.ISSUED,F.REDO.NCF.ISSUED)

    CALL OPF(FN.REDO.NCF.STATUS,F.REDO.NCF.STATUS)

    CALL OPF(FN.TRANSACTION,F.TRANSACTION)

    CALL OPF(FN.REDO.L.NCF.CANCELLED,F.REDO.L.NCF.CANCELLED)

    CALL OPF(FN.FT,F.FT)

    CALL OPF(FN.FT.HIS,F.FT.HIS)

RETURN
*********
PROCESS:
*********
*Updating the NCF.CANCELLED table


    VAL.NCF=R.NEW(FT.LOCAL.REF)<1,POS.FT.NCF.NUM>
    VAL.NCF.TAX=R.NEW(FT.LOCAL.REF)<1,POS.FT.NCF.TAX.NUM>

    VAL.STATUS=R.NEW(FT.RECORD.STATUS)

    VAR.TXN.DATE=R.NEW(FT.DATE.TIME)
    VAR.DATE=20:VAR.TXN.DATE[1,6]

    VAR.CUS=R.NEW(FT.CREDIT.CUSTOMER)
    VAR.TXN.REF = R.NEW(FT.LOCAL.REF)<1,POS.FT.TXN.REF>

    TXN.ID=ID.NEW
    REC.ID=VAR.CUS:'.':VAR.DATE:'.':TXN.ID

    CALL F.READ(FN.FT,VAR.TXN.REF,R.FT,F.FT,FT.ERR)

    IF NOT(R.FT) THEN
        VAR.FT.ID = VAR.TXN.REF
        CALL EB.READ.HISTORY.REC(F.FT.HIS,VAR.FT.ID,R.FT,FT.ERR)
    END

    Y.TXN.DATE = R.FT<FT.DATE.TIME>
    Y.DATE     = 20:Y.TXN.DATE[1,6]
    VAR.REC.ID = VAR.CUS:'.':Y.DATE:'.':VAR.TXN.REF

    IF VAL.NCF NE '' OR VAL.NCF.TAX NE '' THEN
*        CALL F.READ(FN.REDO.NCF.ISSUED,VAR.REC.ID,R.REDO.NCF.ISSUED,F.REDO.NCF.ISSUED,ERR.ISSUE)
        CALL F.READU(FN.REDO.NCF.ISSUED,VAR.REC.ID,R.REDO.NCF.ISSUED,F.REDO.NCF.ISSUED,ERR.ISSUE,'');* R22 UTILITY AUTO CONVERSION
*        CALL F.READ(FN.REDO.L.NCF.CANCELLED,REC.ID,R.REDO.L.NCF.CANCELLED,F.REDO.L.NCF.CANCELLED,ERR.CANCEL)
        CALL F.READU(FN.REDO.L.NCF.CANCELLED,REC.ID,R.REDO.L.NCF.CANCELLED,F.REDO.L.NCF.CANCELLED,ERR.CANCEL,'');* R22 UTILITY AUTO CONVERSION
        R.REDO.L.NCF.CANCELLED<NCF.CAN.TXN.ID>=R.REDO.NCF.ISSUED<ST.IS.TXN.ID>
        R.REDO.L.NCF.CANCELLED<NCF.CAN.TXN.TYPE>=R.REDO.NCF.ISSUED<ST.IS.TXN.TYPE>
        R.REDO.L.NCF.CANCELLED<NCF.CAN.DATE>=R.REDO.NCF.ISSUED<ST.IS.DATE>
        R.REDO.L.NCF.CANCELLED<NCF.CAN.CHARGE.AMOUNT>=R.REDO.NCF.ISSUED<ST.IS.CHARGE.AMOUNT>
        R.REDO.L.NCF.CANCELLED<NCF.CAN.TAX.AMOUNT>=R.REDO.NCF.ISSUED<ST.IS.TAX.AMOUNT>
        R.REDO.L.NCF.CANCELLED<NCF.CAN.NCF>=R.REDO.NCF.ISSUED<ST.IS.NCF>
        R.REDO.L.NCF.CANCELLED<NCF.CAN.MODIFIED.NCF>=R.REDO.NCF.ISSUED<ST.IS.MODIFIED.NCF>
        R.REDO.L.NCF.CANCELLED<NCF.CAN.ACCOUNT>=R.REDO.NCF.ISSUED<ST.IS.ACCOUNT>
        CALL F.WRITE(FN.REDO.L.NCF.CANCELLED,REC.ID,R.REDO.L.NCF.CANCELLED)
*        CALL F.READ(FN.REDO.NCF.STATUS,VAR.REC.ID,R.REDO.NCF.STATUS,F.REDO.NCF.STATUS,ERR.STATUS)
        CALL F.READU(FN.REDO.NCF.STATUS,VAR.REC.ID,R.REDO.NCF.STATUS,F.REDO.NCF.STATUS,ERR.STATUS,'');* R22 UTILITY AUTO CONVERSION
        R.REDO.NCF.STATUS<NCF.ST.STATUS>='CANCELLED'
        CALL F.WRITE(FN.REDO.NCF.STATUS,VAR.REC.ID,R.REDO.NCF.STATUS)
        CALL F.DELETE(FN.REDO.NCF.ISSUED,VAR.REC.ID)
    END
RETURN
END
