SUBROUTINE REDO.E.NOF.BILL.DETAILS(Y.AA.ID,Y.TOTAL.BALANCE.DUE,Y.COMMISSION.CHARGE.BALANCE)
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : TAM.E.NOF.LOAN.EXP.DATE
*--------------------------------------------------------------------------------------------------------
*Description  : CALL routine used to calculate the total balance due and total commission balance
*In Parameter : Y.AA.ID
*Out Parameter: Y.TOTAL.BALANCE.DUE,Y.COMMISSION.CHARGE.BALANCE
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------                -------------            -------------
*  15th SEPT 2010   JEEVA T              ODR-2010-03-0152        Initial Creation
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.BILL.DETAILS
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_F.DEPT.ACCT.OFFICER



    GOSUB OPEN.FILE
    GOSUB PROCESS

RETURN
*-----------------------------------------------------------------------------
OPEN.FILE:
*-----------------------------------------------------------------------------
    FN.AA.BILL.DETAILS='F.AA.BILL.DETAILS'
    F.AA.BILL.DETAILS=''
    CALL OPF(FN.AA.BILL.DETAILS,F.AA.BILL.DETAILS)

    FN.AA.ACCOUNT.DETAILS='F.AA.ACCOUNT.DETAILS'
    F.AA.ACCOUNT.DETAILS=''
    CALL OPF(FN.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS)

    Y.OS.PR.AMOUNT=''
    Y.OS.PR.AMOUNT1=''

RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    CALL F.READ(FN.AA.ACCOUNT.DETAILS,Y.AA.ID,R.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS,Y.AA.ACCOUNT.DETAILS.ERR)
    Y.BILL.LIST=R.AA.ACCOUNT.DETAILS<AA.AD.BILL.ID>
    CHANGE @SM TO @FM IN Y.BILL.LIST
    CHANGE @VM TO @FM IN Y.BILL.LIST
    Y.BILL.LIST.SIZE=DCOUNT(Y.BILL.LIST,@FM)
    Y.BILL.CNT=1

    LOOP
    WHILE Y.BILL.CNT LE Y.BILL.LIST.SIZE
        IF Y.BILL.LIST<Y.BILL.CNT> NE '' THEN
            CALL F.READ(FN.AA.BILL.DETAILS,Y.BILL.LIST<Y.BILL.CNT>,R.AA.BILL.DETAILS,F.AA.BILL.DETAILS,Y.AA.BILL.DETAILS.ERR)
            Y.PAY.PROPERTY=R.AA.BILL.DETAILS<AA.BD.PAY.PROPERTY>
            GOSUB BALANCE.DUE
            GOSUB COMMISSION.BALANCE
        END
        Y.BILL.CNT += 1
    REPEAT

RETURN
*-----------------------------------------------------------------------------
BALANCE.DUE:
*-----------------------------------------------------------------------------
    CHANGE @VM TO @FM IN Y.PAY.PROPERTY
    CHANGE @SM TO @FM IN Y.PAY.PROPERTY
    CHANGE '\' TO @FM IN Y.PAY.PROPERTY

    Y.TOT=R.AA.BILL.DETAILS<AA.BD.OS.PR.AMT>
    CHANGE @VM TO @FM IN Y.TOT
    CHANGE @SM TO @FM IN Y.TOT
    CHANGE '\' TO @FM IN Y.TOT

    Y.P.CNT1 = DCOUNT(Y.PAY.PROPERTY,@FM)
    Y.CNT1=1

    LOOP
    WHILE Y.CNT1 LE Y.P.CNT1

        IF Y.PAY.PROPERTY<Y.CNT1> EQ 'APAPB4ARREAR' OR Y.PAY.PROPERTY<Y.CNT1> EQ 'PRMORA' THEN
            IF Y.OS.PR.AMOUNT1 EQ '' THEN
                Y.OS.PR.AMOUNT1 = Y.TOT<Y.CNT1>
            END ELSE
                Y.OS.PR.AMOUNT1 = Y.OS.PR.AMOUNT1 + Y.TOT<Y.CNT1>
            END
            Y.TOTAL.BALANCE.DUE =Y.OS.PR.AMOUNT1
        END
        Y.CNT1 += 1

    REPEAT

RETURN
*-----------------------------------------------------------------------------
COMMISSION.BALANCE:
*-----------------------------------------------------------------------------

    CHANGE @VM TO @FM IN Y.PAY.PROPERTY
    CHANGE '\' TO @FM IN Y.PAY.PROPERTY
    CHANGE @SM TO @FM IN Y.PAY.PROPERTY

    Y.TOT=R.AA.BILL.DETAILS<AA.BD.OS.PR.AMT>
    CHANGE @VM TO @FM IN Y.TOT
    CHANGE '\' TO @FM IN Y.TOT
    CHANGE @SM TO @FM IN Y.TOT

    Y.P.CNT2 = DCOUNT(Y.PAY.PROPERTY,@FM)
    Y.CNT2=1

    LOOP
    WHILE Y.CNT2 LE Y.P.CNT2
        IF Y.PAY.PROPERTY<Y.CNT2> EQ 'APAPB4INSMNG' OR Y.PAY.PROPERTY<Y.CNT2> MATCHES "...SEG..." THEN

            IF Y.OS.PR.AMOUNT EQ '' THEN
                Y.OS.PR.AMOUNT = Y.TOT<Y.CNT2>
            END ELSE
                Y.OS.PR.AMOUNT= Y.OS.PR.AMOUNT + Y.TOT<Y.CNT2>
            END
            Y.COMMISSION.CHARGE.BALANCE=Y.OS.PR.AMOUNT
        END
        Y.CNT2 += 1
    REPEAT
RETURN
*-----------------------------------------------------------------------------
END
