* @ValidationCode : MjoxNjI3MTc1Mjc6Q3AxMjUyOjE2ODE5NzAwNzE4Nzg6SVRTUzotMTotMTo1NzI6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 20 Apr 2023 11:24:31
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 572
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TEST
SUBROUTINE REDO.INP.VALIDATE.TXN.AMT
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.INP.VALIDATE.TXN.AMT
*--------------------------------------------------------------------------------------------------------
*Description  : This validation is to check the account status and throw error well before transactions validation occurs
*               This routine has to be attached to versions used in ATM transaction. Application can be FT,AC.LOCKED.EVENTS
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------          ------               -------------            -------------
* 1 OCT  2011     KAVITHA                PACS00137917             * PACS00137917 FIX
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*19-04-2023            CONVERSION TOOL                AUTO R22 CODE CONVERSION           VM TO @VM ,FM TO @FM
*19-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.AC.LOCKED.EVENTS
    $INSERT I_AT.ISO.COMMON
    $INSERT I_F.LIMIT
*   $INSERT I_F.AC.LOCKED.EVENTS ;* R22 Auto converted
    $INSERT I_ATM.BAL.ENQ.COMMON
    $INSERT I_F.REDO.INTRANSIT.LOCK
    $INSERT I_REDO.TELLER.COMMON



    IF V$FUNCTION EQ 'R' THEN
        RETURN
    END

    GOSUB OPEN.FILES
    GOSUB PROCESS

RETURN
*--------------------------------------------------------------------------------------------------------
OPEN.FILES:
************


    FN.ALE = 'F.AC.LOCKED.EVENTS'
    F.ALE = ''
    CALL OPF(FN.ALE,F.ALE)

    FN.REDO.TRANSIT.LOCK = 'F.REDO.INTRANSIT.LOCK'
    F.REDO.TRANSIT.LOCK = ''
    CALL OPF(FN.REDO.TRANSIT.LOCK,F.REDO.TRANSIT.LOCK)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
*
*Get the local refernce field L.AC.STATUS2
*
    LOC.REF.ACC.APPL='ACCOUNT'

    LOC.REF.ACC.FIELDS='L.AC.STATUS1':@VM:'L.AC.TRANS.LIM':@VM:'L.AC.AV.BAL':@VM:'L.AC.TRAN.AVAIL'
    LOC.REF.ACC.POS=''
    CALL MULTI.GET.LOC.REF(LOC.REF.ACC.APPL,LOC.REF.ACC.FIELDS,LOC.REF.ACC.POS)

    POS.AC.STAT=LOC.REF.ACC.POS<1,1>
    LOC.L.AC.TRANSIT.LIM  = LOC.REF.ACC.POS<1,2>
    LOC.L.AC.AV.BAL.POS = LOC.REF.ACC.POS<1,3>
    TRAN.AVAIL.POS = LOC.REF.ACC.POS<1,4>

    FN.LIMIT= 'F.LIMIT'
    F.LIMIT = ''
    CALL OPF(FN.LIMIT,F.LIMIT)

    Y.ACCT.NUM = ''

    COMM.AMT = ''
    CHARGE.AMT = ''
    Y.LIMIT.FIRST.PART = ''
    Y.LIMIT.SECOND.PART = ''
    Y.LIMIT.FIRST.PART = ''
    Y.LIMIT.REF.ID = ''
    R.LIMIT  = ''
    Y.LIMIT.AVAIL.AMT = ''

    DR.AMOUNT = ''
    TOTAL.AMT = ''
    L.AC.AV.BAL = ''
    GET.TRANSIT.LIM = ''
    GET.AVAIL.LIM = ''
    Y.CUSTOMER = ''
    Y.LIMIT.REF = ''

RETURN
*--------------------------------------------------------------------------------------------------------
PROCESS:
*********
* If application is 'FUNDS.TRANSFER' then take DEBIT.ACCT.NO field value as account number
* If application is 'AC.LOCKED.EVENTS' then AC.LCK.ACCOUNT.NUMBER field value as account number
*


    IF APPLICATION EQ 'FUNDS.TRANSFER' THEN
        Y.ACCT.NUM = R.NEW(FT.DEBIT.ACCT.NO)

        TOT.CHRG= R.NEW(FT.TOTAL.CHARGE.AMOUNT)
        DR.AMOUNT = R.NEW(FT.DEBIT.AMOUNT)

        IF DR.AMOUNT EQ '' THEN
            DR.AMOUNT = R.NEW(FT.CREDIT.AMOUNT)
        END
        TOT.CHRG = TOT.CHRG[4,8]        ;* PACS00624626
        TOTAL.AMT = DR.AMOUNT + TOT.CHRG

    END

    IF APPLICATION EQ 'AC.LOCKED.EVENTS' THEN
        Y.ACCT.NUM =  R.NEW(AC.LCK.ACCOUNT.NUMBER)
        TOTAL.AMT =  R.NEW(AC.LCK.LOCKED.AMOUNT)
    END


    CALL F.READ(FN.ACCOUNT,Y.ACCT.NUM,R.ACCOUNT,F.ACCOUNT,Y.ERR.AC)

    IF R.ACCOUNT NE '' AND R.ACCOUNT<AC.CUSTOMER> NE '' THEN

        GET.TRANSIT.LIM = R.ACCOUNT<AC.LOCAL.REF><1,LOC.L.AC.TRANSIT.LIM>
        GET.AVAIL.LIM = R.ACCOUNT<AC.LOCAL.REF,TRAN.AVAIL.POS>

        Y.CUSTOMER = R.ACCOUNT<AC.CUSTOMER>
        Y.LIMIT.REF = R.ACCOUNT<AC.LIMIT.REF>
        IF Y.LIMIT.REF THEN
            Y.LIMIT.FIRST.PART = FIELD(Y.LIMIT.REF,'.',1,1)
            Y.LIMIT.SECOND.PART = FIELD(Y.LIMIT.REF,'.',2,1)
            Y.LIMIT.FIRST.PART = FMT(Y.LIMIT.FIRST.PART,'7"0"R')
            Y.LIMIT.REF.ID = Y.CUSTOMER:'.':Y.LIMIT.FIRST.PART:'.':Y.LIMIT.SECOND.PART
            CALL F.READ(FN.LIMIT,Y.LIMIT.REF.ID,R.LIMIT,F.LIMIT,LIMIT.ERR)
            IF R.LIMIT THEN
                Y.LIMIT.AVAIL.AMT = R.LIMIT<LI.AVAIL.AMT,1>
            END
        END


        GOSUB VALIDATE.AMOUNT
    END


RETURN

*------------------------------------------------------------------------------------------------------
VALIDATE.AMOUNT:


    ACCT.FUNDS.AVAIL.1 = L.AC.AV.BALANCE + GET.AVAIL.LIM + Y.LIMIT.AVAIL.AMT
    ACCT.FUNDS.AVAIL.2 = L.AC.AV.BALANCE + GET.TRANSIT.LIM + Y.LIMIT.AVAIL.AMT

    IF ACCT.FUNDS.AVAIL.1 LT ACCT.FUNDS.AVAIL.2 THEN
        ACCT.FUNDS.AVAIL = ACCT.FUNDS.AVAIL.1
    END ELSE
        ACCT.FUNDS.AVAIL = ACCT.FUNDS.AVAIL.2
    END

    IF TOTAL.AMT GT ACCT.FUNDS.AVAIL THEN
        AF = AC.LCK.LOCKED.AMOUNT
        ETEXT = 'EB-AVAIL.BAL.CHECK'
        CALL STORE.END.ERROR
    END


RETURN
*------------------------------------------------------------------------------------------------------------
END
