* @ValidationCode : MjozODU5MzMzMjI6Q3AxMjUyOjE2ODI0MjAwMzk2Njg6MzMzc3U6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Apr 2023 16:23:59
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
*-----------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*25/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION        VM TO @VM, ++ TO +=
*25/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*-----------------------------------------------------------------------------------
SUBROUTINE REDO.CUR.BAL.PAY(BALANCE)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :H GANESH
*Program   Name    :REDO.NXT.BILL.AMT
*---------------------------------------------------------------------------------

*DESCRIPTION       :This program is used to get the value of TXN.AMOUNT
*                   for TELLER & FT
*
*LINKED WITH       : TT.OVER.PYMNT  & FT.OVER.PYMNT
* ----------------------------------------------------------------------------------

* Modification History :
*-----------------------
*DATE             WHO                    REFERENCE         DESCRIPTION
*20.12.2009      H GANESH            ODR-2009-10-0305  INITIAL CREATION
*----------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCT.ACTIVITY
    $INSERT I_F.ACCT.BALANCE.ACTIVITY
    $INSERT I_F.TELLER
    $INSERT I_F.FUNDS.TRANSFER



    GOSUB OPENFILES
    GOSUB PROCESS
RETURN
*-------------------------------------------------------------------------------
OPENFILES:
*-------------------------------------------------------------------------------
    FN.ACCT.ACTIVITY='F.ACCT.BALANCE.ACTIVITY'
    F.ACCT.ACTIVITY=''
    CALL OPF(FN.ACCT.ACTIVITY,F.ACCT.ACTIVITY)


RETURN
*-------------------------------------------------------------------------------
PROCESS:
*-------------------------------------------------------------------------------


    IF APPLICATION EQ 'TELLER' THEN
        GOSUB TELLER
    END
    IF APPLICATION EQ 'FUNDS.TRANSFER' THEN
        GOSUB FT
    END

RETURN
*--------*
TELLER:
*--------*
* This gosub is for TELLER
    Y.ACCOUNT.ID = R.NEW(TT.TE.ACCOUNT.2)
    VALUE.DATE=R.NEW(TT.TE.VALUE.DATE.2)
    Y.YEAR=VALUE.DATE[1,4]
    Y.MONTH=VALUE.DATE[5,2]

    GOSUB SELECTION
RETURN

*--------*
FT:
*--------*
* This gosub is for FT
    Y.ACCOUNT.ID = R.NEW(FT.CREDIT.ACCT.NO)
    VALUE.DATE=R.NEW(FT.CREDIT.VALUE.DATE)
    Y.YEAR=VALUE.DATE[1,4]
    Y.MONTH=VALUE.DATE[5,2]

    GOSUB SELECTION
RETURN
*--------*
SELECTION:
*--------*
* Calculate the Current balance of loan after overpayment


*TUS change START
*SEL.CMD="SELECT ":FN.ACCT.ACTIVITY:" WITH @ID EQ ":Y.ACCOUNT.ID:".CURACCOUNT-":Y.YEAR:Y.MONTH
    SEL.CMD="SELECT ":FN.ACCT.ACTIVITY:" WITH @ID EQ ":Y.ACCOUNT.ID:"-":Y.YEAR:Y.MONTH
    CALL EB.READLIST(SEL.CMD,Y.ACCT.ID,'',NOF,ACCT.ERR)
    VAR1=1
    LOOP
    WHILE VAR1 LE NOF
        Y.ACCT.ID.1=Y.ACCT.ID<VAR1>
        R.ACCT.BAL = ''
        R.ACCT.ACTIVITY.TEMP = ''
        CALL F.READ(FN.ACCT.ACTIVITY,Y.ACCT.ID.1,R.ACCT.BAL,F.ACCT.ACTIVITY,ACCT.ERR1)
        IF R.ACCT.BAL THEN
            LOCATE 'CURACCOUNT' IN R.ACCT.BAL<1, 1> SETTING ACT.BAL.TYPE.POS THEN
                R.ACCT.ACTIVITY.TEMP = R.ACCT.BAL<2, ACT.BAL.TYPE.POS>
                R.ACCT.ACTIVITY = RAISE(RAISE(R.ACCT.ACTIVITY.TEMP))

            END
        END
*TUS change END
        Y.BALANCE=R.ACCT.ACTIVITY<IC.ACT.BALANCE>
        Y.BALANCE.NO=DCOUNT(Y.BALANCE,@VM)
        BALANCE=R.ACCT.ACTIVITY<IC.ACT.BALANCE,Y.BALANCE.NO>
        VAR1 += 1
    REPEAT
RETURN
END
