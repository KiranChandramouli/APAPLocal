* @ValidationCode : MjotMjA5NDYyODEzOTpVVEYtODoxNzAzMjUxODU2NDI3OkFkbWluOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 22 Dec 2023 19:00:56
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : Admin
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.BLD.GET.STMT.ID.ARC(ENQ.DATA)
****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : PRABHU N
* Program Name  : REDO.E.BLD.VAL.ACCOUNT
*-------------------------------------------------------------------------
* Description: This routine is a build routine attached to all enquiries
* related to showing last five transactions
*----------------------------------------------------------
* Linked with: All enquiries with Customer no as selection field
* In parameter : ENQ.DATA
* out parameter : None
*------------------------------------------------------------------------
* MODIFICATION HISTORY
*--------------------------------------------
*   DATE              ODR                             DESCRIPTION
* 09-09-2010         ODR-2010-08-0031                Routine for STMT.ENTRY
* 10-06-2015         PACS00460203       modification for fix
* 10-APRIL-2023      Conversion Tool       R22 Auto Conversion  - VM to @VM , FM to @FM ,SM to @SM , ++ to +=1 and -- to -=1
* 10-APRIL-2023      Harsha                R22 Manual Conversion - No changes
* 22-12-2023         Narmadha V            Manual R22 Conversion - Changed ID variable instead of Hardcoding
*------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.EB.CONTRACT.BALANCES
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.STMT.ENTRY
    $INSERT I_F.AI.REDO.ARCIB.PARAMETER

    GOSUB OPENFILES
    GOSUB PROCESS
    GOSUB PGM.END

RETURN

*---------
OPENFILES:
*---------
*Tables required:ACCT.STMT.PRINT and STMT.PRINTED
*----------------------------------------------------------------------------------

    FN.ACCT.STMT.PRINT= 'F.ACCT.STMT.PRINT'
    F.ACCT.STMT.PRINT=''
    CALL OPF(FN.ACCT.STMT.PRINT,F.ACCT.STMT.PRINT)

    FN.STMT.PRINTED='F.STMT.PRINTED'
    F.STMT.PRINTED =''
    CALL OPF(FN.STMT.PRINTED,F.STMT.PRINTED)


    FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'
    F.AZ.ACCOUNT  = ''
    CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)

    FN.STMT.ENTRY = 'F.STMT.ENTRY'
    F.STMT.ENTRY  =  ''
    CALL OPF(FN.STMT.ENTRY,F.STMT.ENTRY)

    FN.AI.REDO.ARCIB.PARAMETER = 'F.AI.REDO.ARCIB.PARAMETER'
    F.AI.REDO.ARCIB.PARAMETER = ''
*  CALL OPF(FN.AI.REDO.ARCIB.PARAMETER,F.AI.REDO.ARCIB.PARAMETER)
    Y.ID = "SYSTEM"
*CALL CACHE.READ(FN.AI.REDO.ARCIB.PARAMETER,'SYSTEM',R.AI.REDO.ARCIB.PARAMETER,ARCIB.ERR)
    CALL CACHE.READ(FN.AI.REDO.ARCIB.PARAMETER,Y.ID,R.AI.REDO.ARCIB.PARAMETER,ARCIB.ERR) ;*Manual R22 Conversion - Changed ID variable instead of Hardcoding
    Y.MIG.PARAM.CODE = R.AI.REDO.ARCIB.PARAMETER<AI.PARAM.MIGRATION.CODE>
    CHANGE @VM TO @FM IN Y.MIG.PARAM.CODE

    LREF.APP = 'ACCOUNT':@FM:'AZ.ACCOUNT'
    LREF.FIELDS = 'L.AC.AV.BAL':@FM:'L.TYPE.INT.PAY'
    LREF.POS=''
    CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELDS,LREF.POS)
    POS.L.AC.AV.BAL        = LREF.POS<1,1>
    POS.L.TYPE.INT.PAY.POS = LREF.POS<2,1>



RETURN

*-----------------------------------------
PROCESS:
*-----------------------------------------
*Get the Account no  from ENQ.DATA and based on account no get last 5 stmt id from EB.CONTRACT.BALANCE and then snd those ids to selection criteria
    LOCATE 'ACCOUNT.NUMBER' IN ENQ.DATA<2,1> SETTING ACCOUNT.POS ELSE
    END

    Y.ACCT.ID=ENQ.DATA<4,1>
    CALL F.READ(FN.ACCT.STMT.PRINT,Y.ACCT.ID,R.ACCT.STMT.PRINT,F.ACCT.STMT.PRINT,ERR)


    R.ACCT.STMT.PRINT.SIZE=DCOUNT(R.ACCT.STMT.PRINT,@FM)
    Y.CNT    =0
    Y.MAX.CNT=5
    IF R.ACCT.STMT.PRINT.SIZE LT 5 THEN
        Y.MAX.CNT =R.ACCT.STMT.PRINT.SIZE
    END
    LOOP
        Y.ACCT.STMT.POS=R.ACCT.STMT.PRINT.SIZE-Y.CNT
        CHANGE '/' TO @SM IN R.ACCT.STMT.PRINT
        R.ACCT.STMT.PRINT.LIST<-1>=R.ACCT.STMT.PRINT<Y.ACCT.STMT.POS,1,1>
        Y.CNT += 1
    WHILE  Y.CNT LT Y.MAX.CNT
    REPEAT


    Y.STMT.PRINT.CNT  = 1
    Y.STMT.PRINT.TOT  = DCOUNT(R.ACCT.STMT.PRINT.LIST,@FM)
    LOOP
    WHILE Y.STMT.PRINT.CNT LE Y.STMT.PRINT.TOT
        Y.STMT.PRINT.ID = R.ACCT.STMT.PRINT.LIST<Y.STMT.PRINT.CNT>
        Y.STMT.PRINT.LIST<-1>  = Y.ACCT.ID:'-':Y.STMT.PRINT.ID
        Y.STMT.PRINT.CNT += 1
    REPEAT

    LOOP
        REMOVE Y.STMT.PRINT.ID FROM Y.STMT.PRINT.LIST SETTING STMT.ENT.COS
    WHILE Y.STMT.PRINT.ID:STMT.ENT.COS
        CALL F.READ(FN.STMT.PRINTED,Y.STMT.PRINT.ID,R.STMT.PRINTED,F.STMT.PRINTED,ERR)
        Y.STMT.ID.LIST<-1>=R.STMT.PRINTED
        Y.TOT.STMT.ID.LIST = DCOUNT(Y.STMT.ID.LIST,@FM)
        IF Y.TOT.STMT.ID.LIST GE 5 THEN
            GOSUB AZ.STMT.LIST.PARA
            GOSUB MIG.SORT.PARA
            GOSUB AZ.SORT.ARRAY
            Y.STMT.ID.LIST = FIELD(Y.FINAL.ID.LIST,@FM,1,5)
            CHANGE @FM TO @SM IN Y.STMT.ID.LIST
            ENQ.DATA<2,1>='@ID'
            ENQ.DATA<3,1>='EQ'
            ENQ.DATA<4,1>=Y.STMT.ID.LIST
            GOSUB PGM.END
        END
    REPEAT

    GOSUB AZ.STMT.LIST.PARA
    GOSUB MIG.SORT.PARA
    GOSUB AZ.SORT.ARRAY
    Y.STMT.ID.LIST = FIELD(Y.FINAL.ID.LIST,@FM,1,Y.TOT.STMT.ID.LIST)
    CHANGE @FM TO @SM IN Y.STMT.ID.LIST
    ENQ.DATA<2,1>='@ID'
    ENQ.DATA<3,1>='EQ'
    ENQ.DATA<4,1>=Y.STMT.ID.LIST
RETURN
******************
AZ.STMT.LIST.PARA:
******************
    CALL F.READ(FN.AZ.ACCOUNT,Y.ACCT.ID,R.AZ.ACCOUNT,F.AZ.ACCOUNT,AZ.ACCOUNT.ERR)
    IF R.AZ.ACCOUNT THEN
        Y.DEP.TYPE       = R.AZ.ACCOUNT<AZ.LOCAL.REF,POS.L.TYPE.INT.PAY.POS>
        IF Y.DEP.TYPE EQ 'Reinvested' THEN
            Y.INTEREST.LIQU.ACCT = R.AZ.ACCOUNT<AZ.INTEREST.LIQU.ACCT>
            APAP.REDOENQ.redoEBldGetStmtAzArc(Y.INTEREST.LIQU.ACCT,Y.AZ.STMT.ID.LIST)    ;*R22 Manual Conversion - Added APAP.REDOENQ
            
            Y.STMT.ID.LIST<-1> = Y.AZ.STMT.ID.LIST
        END
    END
RETURN
**************
MIG.SORT.PARA:
**************
    Y.MIG.TOT.CNT = DCOUNT(Y.STMT.ID.LIST,@FM)

    Y.MIG.INT = 1
    LOOP
    WHILE Y.MIG.INT LE Y.MIG.TOT.CNT
        Y.MIG.STMT.ID = Y.STMT.ID.LIST<Y.MIG.INT>
        CALL F.READ(FN.STMT.ENTRY,Y.MIG.STMT.ID,R.STMT.ENTRY,F.STMT.ENTRY,SE.ERR)
        Y.MIG.TXN.CODE = R.STMT.ENTRY<AC.STE.TRANSACTION.CODE>
        LOCATE  Y.MIG.TXN.CODE IN Y.MIG.PARAM.CODE SETTING Y.MIG.POS THEN
            DEL Y.STMT.ID.LIST<Y.MIG.INT>
        END
        Y.MIG.INT += 1
    REPEAT

RETURN
**************
AZ.SORT.ARRAY:
***************

    Y.AZ.TOT.CNT = DCOUNT(Y.STMT.ID.LIST,@FM)
    Y.AZ.INT = 1
    LOOP
    WHILE Y.AZ.INT LE Y.AZ.TOT.CNT
        Y.AZ.STMT.ID = Y.STMT.ID.LIST<Y.AZ.INT>
        CALL F.READ(FN.STMT.ENTRY,Y.AZ.STMT.ID,R.STMT.ENTRY,F.STMT.ENTRY,SE.ERR)
        Y.AZ.DATE.TIME = R.STMT.ENTRY<AC.STE.DATE.TIME>
        Y.FINAL.SORT.LIST<-1> = Y.AZ.STMT.ID:@FM:Y.AZ.DATE.TIME
        Y.SORT.ARR<-1> = Y.AZ.DATE.TIME
        Y.AZ.INT += 1
    REPEAT
    Y.SORT.ARR = SORT(Y.SORT.ARR)
    Y.REC.COUNT = DCOUNT(Y.SORT.ARR,@FM)
    Y.REC.START = 1
    LOOP

    WHILE Y.REC.COUNT GE Y.REC.START
        Y.REC = Y.SORT.ARR<Y.REC.COUNT>
        Y.REC = TRIM(Y.REC)
*--------------------PACS00460203-----------------------------------------
        LOCATE Y.REC IN Y.FINAL.SORT.LIST SETTING Y.FM.POS THEN
*--------------------PACS00460203-----------------------------------------
* LOCATE Y.REC IN Y.FINAL.SORT.LIST BY 'DR' SETTING Y.FM.POS THEN
            Y.FINAL.ID.LIST<-1> = Y.FINAL.SORT.LIST<Y.FM.POS-1>
            DEL Y.FINAL.SORT.LIST<Y.FM.POS>
            DEL Y.FINAL.SORT.LIST<Y.FM.POS-1>
        END
        Y.REC.COUNT -= 1
    REPEAT
RETURN

PGM.END:
END
