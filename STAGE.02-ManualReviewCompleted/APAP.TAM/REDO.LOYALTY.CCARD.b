$PACKAGE APAP.TAM
SUBROUTINE REDO.LOYALTY.CCARD(Y.FINAL.ARRAY)
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This is an Nofile routine to get some data for enquiry REDO.LOY.INFOF360
* related to B.25 Loyalty Module.
*
* Input/Output:
*--------------
* IN : CUSTOMER.ID
* OUT : R.DATA (ALL DATA)
*---------------
*-----------------------------------------------------------------------------
* Modification History :
*   Date            Who                   Reference               Description
** 12-04-2023 R22 Auto Conversion - FM TO @FM, VM to @VM, SM to @SM
** 12-04-2023 R22 Auto Conversion no changes
*-----------------------------------------------------------------------------
* <region name= Inserts>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_EB.EXTERNAL.COMMON
    $INSERT I_System


* </region>
*-----------------------------------------------------------------------------
    GOSUB INIT
    GOSUB PROCESS

RETURN
*****
INIT:
*****
    FN.REDO.EB.USER.PRINT.VAR='F.REDO.EB.USER.PRINT.VAR'
    F.REDO.EB.USER.PRINT.VAR=''
    CALL OPF(FN.REDO.EB.USER.PRINT.VAR,F.REDO.EB.USER.PRINT.VAR)

    Y.USR.VAR = System.getVariable("EXT.EXTERNAL.USER")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN ;* R22 Auto conversion
        Y.USR.VAR = "" ;* R22 Auto conversion
    END ;* R22 Auto conversion

    Y.HTML.VAR = Y.USR.VAR:"-":"CURRENT.CARD.LIST.CUS"

*  READ Y.CARD.LIST FROM F.REDO.EB.USER.PRINT.VAR,Y.HTML.VAR ELSE ;*Tus Start
    CALL F.READ(FN.REDO.EB.USER.PRINT.VAR,Y.HTML.VAR,Y.CARD.LIST,F.REDO.EB.USER.PRINT.VAR,Y.CARD.LIST.ERR)
    IF Y.CARD.LIST.ERR THEN  ;* Tus end
        Y.CARD.LIST = ''
    END

    Y.HTML.VAR = Y.USR.VAR:"-":"CURRENT.CARD.CORTE"

*  READ HTML.HEADER FROM F.REDO.EB.USER.PRINT.VAR,Y.HTML.VAR ELSE ;*Tus Start
    CALL F.READ(FN.REDO.EB.USER.PRINT.VAR,Y.HTML.VAR,HTML.HEADER,F.REDO.EB.USER.PRINT.VAR,HTML.HEADER.ERR)
    IF HTML.HEADER.ERR THEN  ;* Tus end
        HTML.HEADER = ''
    END
    Y.CORTE = HTML.HEADER<1,2>
    Y.DATE.MONTH=Y.CORTE[5,2]
    Y.DATE.YEAR =Y.CORTE[1,4]
    Y.COMPANY.CODE= System.getVariable('CURRENT.COMP.CODE')
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN ;* R22 Auto conversion
        Y.COMPANY.CODE = "" ;* R22 Auto conversion
    END ;* R22 Auto conversion
    Y.COMPANY.CODE = 1
    Y.CURRENCY     = 1

    Y.BAL.INT = 0
    Y.GEN.PNT = 0
    Y.DUE.PNT = 0
    Y.BAL.FIN = 0
    Y.FINAL.ARRAY = ''

RETURN
*-------
PROCESS:
*-------

    CHANGE '*' TO @FM IN Y.CARD.LIST
    Y.CARD.TOT = DCOUNT(Y.CARD.LIST,@FM)

    Y.CARD.CNT = 1
    LOOP
    WHILE Y.CARD.CNT LE Y.CARD.TOT
        Y.ARRAY='BE_K_TC.BE_P_CON_ESTCUENTATC_A'
        D.FIELDS= 'CARD.NO':@FM:'COMPANY.CODE':@FM:'START.DATE':@FM:'END.DATE':@FM:'CURRENCY'
        D.RANGE.AND.VALUE=Y.CARD.LIST<Y.CARD.CNT>:@FM:Y.COMPANY.CODE:@FM:Y.DATE.MONTH:@FM:Y.DATE.YEAR:@FM:Y.CURRENCY
        CALL REDO.V.WRAP.SUNNEL(Y.ARRAY)

        Y.MSG.DESC=Y.ARRAY<29>
        Y.ALL.DATA=Y.ARRAY<25>
        IF Y.ARRAY<28> NE '0' THEN
            RETURN
        END
        Y.BAL.INT + = Y.ARRAY<13>
        Y.GEN.PNT + = Y.ARRAY<14>
        Y.DUE.PNT + = Y.ARRAY<15>
        Y.BAL.FIN + = Y.ARRAY<19>

        IF Y.CURRENCY EQ 1 THEN
            Y.FINAL.ARRAY<-1> = Y.CARD.LIST<Y.CARD.CNT> : "##" : Y.ARRAY<13> : "##" : Y.ARRAY<14> : "##" : Y.ARRAY<15> : "##" : Y.ARRAY<19>
        END
        ELSE
            Y.FINAL.ARRAY<-1> = Y.CARD.LIST<Y.CARD.CNT> : "##" : Y.ARRAY<13> : "##" : Y.ARRAY<14> : "##" : Y.ARRAY<15> : "##" : Y.ARRAY<19>
        END
        Y.CARD.CNT += 1 ;* R22 Auto conversion
    REPEAT
    IF Y.FINAL.ARRAY THEN
        Y.FINAL.ARRAY<-1> = 'TOTALES' : "##" : Y.BAL.INT : "##" : Y.GEN.PNT : "##" : Y.DUE.PNT : "##" : Y.BAL.FIN
    END ELSE
        Y.FINAL.ARRAY<-1> = 'TOTALES' : "##" : 0.00 : "##" : 0.00 : "##" : 0.00 : "##" : 0.00
    END

RETURN
END
