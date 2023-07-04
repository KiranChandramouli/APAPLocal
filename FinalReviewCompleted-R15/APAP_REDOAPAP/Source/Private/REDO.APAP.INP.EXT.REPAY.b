* @ValidationCode : Mjo5OTI0NTMxMjk6Q3AxMjUyOjE2ODQ4MzYwNDIzMzM6SVRTUzotMTotMToxNDA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 May 2023 15:30:42
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 140
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.INP.EXT.REPAY
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.AUTO.TRANS.DAY
*--------------------------------------------------------------------------------------------------------
*Description  : This is input routine, which validates for a valid loan account
*               number of the customer and also updates the local field
*               Release Transit Date
*Linked With  : Version TELLER,AA.REPAY.EXTERNALCHEQUE
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 8th JUN 2010    Mohammed Anies K   ODR-2009-10-1678 B.10      Initial Creation
* Date                  who                   Reference              
* 05-04-2023        �CONVERSTION TOOL   �  R22 AUTO CONVERSTION VM TO @VM
* 05-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.CHEQUE.REGISTER
    $INSERT I_F.CHEQUE.COLLECTION
*--------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
    GOSUB OPEN.PARA
    GOSUB PROCESS.PARA
RETURN
*--------------------------------------------------------------------------------------------------------
**********
OPEN.PARA:
**********
* In this para of code file variables are initialised and opened

    FN.AA.ARRANGEMENT='F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT=''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* Main processing section

    GOSUB FIND.MULTI.LOCAL.REF
    GOSUB CHECK.ACCOUNT.2
    GOSUB UPDATE.TRANS.DATE

RETURN
*--------------------------------------------------------------------------------------------------------
****************
CHECK.ACCOUNT.2:
****************
* In this para of code, account entered in ACCOUNT.2 field is validated

    AA.ARRANGEMENT.ID = R.NEW(TT.TE.LOCAL.REF)<1,LOC.L.TT.ARRANGE.ID.POS>
    GOSUB READ.AA.ARRANGEMENT

    IF NOT(R.AA.ARRANGEMENT) THEN
        RETURN
    END

    IF R.NEW(TT.TE.ACCOUNT.2) NE R.AA.ARRANGEMENT<AA.ARR.LINKED.APPL.ID> THEN
        AF=TT.TE.ACCOUNT.2
        ETEXT='TT-CR.ACC.NE.LOAN.AC'
        CALL STORE.END.ERROR
    END

RETURN
*--------------------------------------------------------------------------------------------------------
********************
READ.AA.ARRANGEMENT:
********************
* AA.ARRANGEMENT record is read for the given arrangement id
    R.AA.ARRANGEMENT=''
    AA.ARRANGEMENT.ERR=''
    CALL F.READ(FN.AA.ARRANGEMENT,AA.ARRANGEMENT.ID,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,AA.ARRANGEMENT.ERR)
*--------------------------------------------------------------------------------------------------------
******************
UPDATE.TRANS.DATE:
******************
*In this para of code, Local reference field trans release date will be updated

    Y.VALUE.DATE=R.NEW(TT.TE.VALUE.DATE.2)
    Y.TRANS.DAYS=R.NEW(TT.TE.LOCAL.REF)<1,LOC.L.TT.TRANS.DAYS.POS>
    CALL CDT(Y.REGION,Y.VALUE.DATE,Y.TRANS.DAYS)
    R.NEW(TT.TE.LOCAL.REF)<1,LOC.L.TT.TRANS.REL.POS>=Y.VALUE.DATE

RETURN
*--------------------------------------------------------------------------------------------------------
*********************
FIND.MULTI.LOCAL.REF:
*********************
*In this para of code local reference field positions are identified

    APPL.ARRAY='TELLER'
    FLD.ARRAY='L.TT.ARRANGE.ID':@VM:'L.TT.TRANS.DAYS':@VM:'L.TT.TRANS.REL'
    FLD.POS=''
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
    LOC.L.TT.ARRANGE.ID.POS = FLD.POS<1,1>
    LOC.L.TT.TRANS.DAYS.POS = FLD.POS<1,2>
    LOC.L.TT.TRANS.REL.POS  = FLD.POS<1,3>

RETURN
*--------------------------------------------------------------------------------------------------------
END
