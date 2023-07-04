* @ValidationCode : MjotMTI2NTIyMTYxMzpDcDEyNTI6MTY4MTM3NjA5ODYzMTpJVFNTOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 13 Apr 2023 14:24:58
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
SUBROUTINE REDO.NCF.CANCEL.AUTH.UPD
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
*This Routine is attached to the version of REDO.L.NCF.CANCEL table.It will create
*record in REDO.L.NCF.CANCELLED & changes status in REDO.L.NCF.STATUS table
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------
*   Date               who           Reference            Description
* 25-MAR-2010        Prabhu.N       ODR-2009-10-0321     Initial Creation
* 13.04.2023       Conversion Tool       R22            Auto Conversion     - No changes
* 13.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*
*--------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.L.NCF.STATUS
    $INSERT I_F.REDO.L.NCF.CANCELLED
    $INSERT I_F.REDO.L.NCF.CANCEL
    $INSERT I_F.REDO.NCF.ISSUED

    FN.REDO.L.NCF.STATUS='F.REDO.L.NCF.STATUS'
    F.REDO.L.NCF.STATUS=''
    CALL OPF(FN.REDO.L.NCF.STATUS,F.REDO.L.NCF.STATUS)

    FN.REDO.L.NCF.ISSUED='F.REDO.NCF.ISSUED'
    F.REDO.L.NCF.ISSUED=''
    CALL OPF(FN.REDO.L.NCF.ISSUED,F.REDO.L.NCF.ISSUED)

    FN.REDO.L.NCF.CANCELLED='F.REDO.L.NCF.CANCELLED'
    F.REDO.L.NCF.CANCELLED=''
    CALL OPF(FN.REDO.L.NCF.CANCELLED,F.REDO.L.NCF.CANCELLED)
    VAR.TRANSACTION=R.NEW(ST.TRANSACTION.ID)


    SEL.ISSUE.CMD="SELECT " : FN.REDO.L.NCF.ISSUED :" WITH TXN.ID EQ ":VAR.TRANSACTION:" AND BATCH NE YES"
    CALL EB.READLIST(SEL.ISSUE.CMD,VAR.ISSUED.ID,'',NO.OF.REC,ERR)
    CALL F.READ(FN.REDO.L.NCF.ISSUED,VAR.ISSUED.ID,R.NCF.ISSUED,F.REDO.L.NCF.ISSUED,ERR)
    R.NCF.CANCEL<NCF.CAN.TXN.ID>=R.NCF.ISSUED<ST.IS.TXN.ID>
    R.NCF.CANCEL<NCF.CAN.TXN.TYPE>=R.NCF.ISSUED<ST.IS.TXN.TYPE>
    R.NCF.CANCEL<NCF.CAN.DATE>=R.NCF.ISSUED<ST.IS.DATE>
    R.NCF.CANCEL<NCF.CAN.CHARGE.AMOUNT>=R.NCF.ISSUED<ST.IS.CHARGE.AMOUNT>
    R.NCF.CANCEL<NCF.CAN.TAX.AMOUNT>=R.NCF.ISSUED<ST.IS.TAX.AMOUNT>
    R.NCF.CANCEL<NCF.CAN.NCF>=R.NCF.ISSUED<ST.IS.NCF>
    R.NCF.CANCEL<NCF.CAN.MODIFIED.NCF>=R.NCF.ISSUED<ST.IS.MODIFIED.NCF>
    R.NCF.CANCEL<NCF.CAN.ACCOUNT>=R.NCF.ISSUED<ST.IS.ACCOUNT>
    R.NCF.CANCEL<NCF.CAN.CUSTOMER>=R.NCF.ISSUED<ST.IS.CUSTOMER>
    R.NCF.CANCEL<NCF.CAN.CAN.TYPE>=R.NEW(ST.CANCEL.TYPE)

    CALL F.READ(FN.REDO.L.NCF.STATUS,VAR.ISSUED.ID,R.NCF.STATUS,F.REDO.L.NCF.STATUS,ST.ERROR)
    R.NCF.STATUS<NCF.ST.STATUS>='CANCELLED'
    CALL F.WRITE(FN.REDO.L.NCF.STATUS,VAR.ISSUED.ID,R.NCF.STATUS)
    CALL F.WRITE(FN.REDO.L.NCF.CANCELLED,VAR.ISSUED.ID,R.NCF.CANCEL)
    CALL F.DELETE(FN.REDO.L.NCF.ISSUED,VAR.ISSUED.ID)
RETURN
END
