* @ValidationCode : Mjo0MDY1MjYwNjU6Q3AxMjUyOjE2ODQ4NDIwOTQ5MTg6SVRTUzotMTotMTo3Nzg6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 May 2023 17:11:34
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 778
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.D.PEND.CHARGES
*-------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This routine is to update tables and raising entries  at time of deletion from Pending charge table

* INPUT/OUTPUT:
*--------------
* IN : N/A
* OUT : N/A

* DEPENDDENCIES:
*-------------------------------------------------------------------------
* CALLED BY :
* CALLS :
* ------------------------------------------------------------------------
*   Date               who           Reference            Description
* 10-FEB-2010     SHANKAR RAJU     ODR-2009-10-0529     Initial Creation
* Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*06/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION           FM TO @FM, VM TO @VM, SM TO @SM
*06/04/2023         SURESH           MANUAL R22 CODE CONVERSION          NOCHANGE
*-------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.STMT.ENTRY
    $INSERT I_F.CATEG.ENTRY
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.USER
    $INSERT I_F.REDO.CHARGE.PARAM
    $INSERT I_F.REDO.PENDING.CHARGE
    $INSERT I_F.REDO.REPAYMENT.CHARGE
    $INSERT I_F.ACCOUNT.CLOSURE


    GOSUB INITIALSE
    GOSUB CHECK.ACCOUNT.BAL

RETURN
*-------------------------------------------------------------------------
INITIALSE:
*~~~~~~~~

    FN.CHARGE.PARAM = 'F.REDO.CHARGE.PARAM'
    F.CHARGE.PARAM = ''
    CALL OPF(FN.CHARGE.PARAM,F.CHARGE.PARAM)

    FN.PENDING.CHARGE = 'F.REDO.PENDING.CHARGE'
    F.PENDING.CHARGE = ''
    CALL OPF(FN.PENDING.CHARGE,F.PENDING.CHARGE)

    FN.REPAYMENT.CHARGE = 'F.REDO.REPAYMENT.CHARGE'
    F.REPAYMENT.CHARGE = ''
    CALL OPF(FN.REPAYMENT.CHARGE,F.REPAYMENT.CHARGE)

    FN.CATEG.ENTRY = 'F.CATEG.ENTRY'
    F.CATEG.ENTRY = ''
    CALL OPF(FN.CATEG.ENTRY,F.CATEG.ENTRY)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

RETURN
*-------------------------------------------------------------------------
CHECK.ACCOUNT.BAL:
*~~~~~~~~~~~~~~~~

    IN.ACCT.NO = ID.NEW
    R.ACCOUNT = ''
    R.PENDING.CHARGE = ''
    PC.ERR = ''
    ACC.ERR = ''
    R.ACC.ARR = ''

    CALL CACHE.READ(FN.CHARGE.PARAM,"SYSTEM",R.CHARGE.PARAM,CHG.ERR)
    RCP.PL.CATEG =  R.CHARGE.PARAM<CHG.PARAM.PL.CATEGORY>


    CALL F.READ(FN.PENDING.CHARGE,IN.ACCT.NO,R.PENDING.CHARGE,F.PENDING.CHARGE,PC.ERR)

    CALL F.READ(FN.ACCOUNT,IN.ACCT.NO,R.ACCOUNT,F.ACCOUNT,ACC.ERR)

    START.COUNT = 1

    IF R.PENDING.CHARGE THEN

        TXN.IDS = R.PENDING.CHARGE<PEN.CHG.TRANSACTION>

        TXN.ID.CNT = DCOUNT(TXN.IDS,@VM)
        LOOP
        WHILE START.COUNT LE TXN.ID.CNT

            CURR.TXN.ID = TXN.IDS<1,START.COUNT>
            AMT.PEND = R.PENDING.CHARGE<PEN.CHG.AMOUNT,START.COUNT>

            SEL.CMD = "SELECT ":FN.CATEG.ENTRY:" WITH TRANS.REFERENCE EQ ":CURR.TXN.ID
            CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NOR,SEL.ERR)
            LOOP
                REMOVE ID.CATEG FROM SEL.LIST SETTING POS1

            WHILE ID.CATEG:POS1

                GOSUB GENERATE.RECOVER.ENTRIES

            REPEAT

            START.COUNT += 1
        REPEAT

        CALL EB.ACCOUNTING("BM.CRCD.MERCH.UPLOAD","SAO",R.ACC.ARR,'')

    END

RETURN

*-------------------------------------------------------------------------
GENERATE.RECOVER.ENTRIES:
*~~~~~~~~~~~~~~~~~~~~~~

    CALL F.READ(FN.CATEG.ENTRY,ID.CATEG,R.CATEG.ENTRY,F.CATEG.ENTRY,CATEG.ERR)

    CALL ALLOCATE.UNIQUE.TIME(CURRTIME)

    IF R.CATEG.ENTRY<AC.CAT.AMOUNT.LCY> LT 0 THEN

        R.CATEG.ENTRY<AC.CAT.AMOUNT.LCY> = AMT.PEND

    END ELSE

        R.CATEG.ENTRY<AC.CAT.AMOUNT.LCY> = AMT.PEND * -1

    END

    R.CATEG.ENTRY<AC.CAT.SYSTEM.ID> = "ACPC"
    R.CATEG.ENTRY<AC.CAT.NARRATIVE> = "REVERSAL"
    R.CATEG.ENTRY<AC.CAT.TRANS.REFERENCE> = "ENQDEL":CURRTIME
    V = FT.AUDIT.DATE.TIME
    R.CATEG.ENTRY = CHANGE(R.CATEG.ENTRY,@VM,@SM)
    R.CATEG.ENTRY = CHANGE(R.CATEG.ENTRY,@FM,@VM)
    IF R.ACC.ARR EQ '' THEN
        R.ACC.ARR = R.CATEG.ENTRY
    END ELSE
        R.ACC.ARR<-1> = R.CATEG.ENTRY
    END
RETURN
*-------------------------------------------------------------------------
END
