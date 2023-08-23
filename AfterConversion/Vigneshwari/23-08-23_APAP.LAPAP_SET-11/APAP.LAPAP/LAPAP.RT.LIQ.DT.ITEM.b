* @ValidationCode : MjoxODkyMjkzODU4OkNwMTI1MjoxNjkyNzc0NDM1NTA4OnZpZ25lc2h3YXJpOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 Aug 2023 12:37:15
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
$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------
* <Rating>270</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE LAPAP.RT.LIQ.DT.ITEM
*------------------------------------------------------------------------------------------------
*
* Modification History :
*-----------------------
*  DATE             WHO             REFERENCE              DESCRIPTION
*09/08/2023       VIGNESHWARI   MANUAL R22 CODE CONVERSION  T24.BP,BP is removed in insertfile
*--------------------------------------------------------------------------------------------------------
*
    $INSERT  I_EQUATE ;*MANUAL R22 CODE CONVERSION-START-T24.BP is removed in insertfile
    $INSERT  I_COMMON
    $INSERT  I_F.TELLER  ;*MANUAL R22 CODE CONVERSION-END
    $INSERT  I_F.LAPAP.TB.LIQ.DT.LOG  ;*MANUAL R22 CODE CONVERSION-STOP-BP is removed in insertfile


    GOSUB LOCREF
    GOSUB OPEN.FILES
    GOSUB INI
*---------------------------------------------------------------------------------------------------------

*----------------------------------------------------------------------------------------------------------
LOCREF:
    APPL.NAME.ARR<1> = 'TELLER' ;
    FLD.NAME.ARR<1,1> = 'L.DT.ID' ;
    FLD.NAME.ARR<1,2> = 'L.DT.INFO' ;
    FLD.NAME.ARR<1,3> = 'L.BOL.DIVISA' ;
    FLD.NAME.ARR<1,4> = 'L.DT.REC' ;

    CALL MULTI.GET.LOC.REF(APPL.NAME.ARR,FLD.NAME.ARR,FLD.POS.ARR)
    L.DT.ID.POS = FLD.POS.ARR<1,1>
    L.DT.INFO.POS = FLD.POS.ARR<1,2>
    L.BOL.DIVISA.POS = FLD.POS.ARR<1,3>
    L.DT.REC.POS = FLD.POS.ARR<1,4>

    RETURN

*----------------------------------------------------------------------------------------------------------
OPEN.FILES:
*~~~~~~~~~~
*

    * LIQ.DT.LOG
    FN.LIQ.DT.LOG = 'F.ST.LAPAP.TB.LIQ.DT.LOG';
    F.LIQ.DT.LOG = ''
    CALL OPF(FN.LIQ.DT.LOG,F.LIQ.DT.LOG)

*
    RETURN
*----------------------------------------------------------------------------------------------------------
INI:

    Y.DT.INFO = R.NEW(TT.TE.LOCAL.REF)<1,L.DT.INFO.POS>
    Y.DT.FORMA.PAGO = FIELD(Y.DT.INFO,'*',6)
    Y.DT.RECEPTION.1 = FIELD(R.NEW(TT.TE.LOCAL.REF)<1,L.DT.REC.POS,1>,'*',1)
    Y.DT.RECEPTION.2 = FIELD(R.NEW(TT.TE.LOCAL.REF)<1,L.DT.REC.POS,2>,'*',1)
    Y.DT.RECEPTION.3 = FIELD(R.NEW(TT.TE.LOCAL.REF)<1,L.DT.REC.POS,3>,'*',1)
    Y.DT.RECEPTION.4 = FIELD(R.NEW(TT.TE.LOCAL.REF)<1,L.DT.REC.POS,4>,'*',1)
    Y.DT.ITEM = FIELD(Y.DT.INFO,'*',2)
    Y.TT.ID = ID.NEW

*DEBUG
    param = Y.DT.ITEM:"::":Y.TT.ID   
    *param = "262::TT999999"   ;
    Y.EB.API.ID = 'LAPAP.LIQ.DT.ITEM'

    PROCESS.GOAHEAD = "1"
    LOOP.CNT        = 1
    MAX.LOOPS       = 1
    
    GOSUB DOCALL

    IF Y.DT.RECEPTION.1 THEN
        Y.DT.FORMA.PAGO = FIELD(R.NEW(TT.TE.LOCAL.REF)<1,L.DT.REC.POS,1>,'*',3)
        param = Y.DT.RECEPTION.1:"::":Y.TT.ID 
        GOSUB DOCALL
    END
    
    IF Y.DT.RECEPTION.2 THEN
        Y.DT.FORMA.PAGO = FIELD(R.NEW(TT.TE.LOCAL.REF)<1,L.DT.REC.POS,2>,'*',3)
        param = Y.DT.RECEPTION.2:"::":Y.TT.ID 
        GOSUB DOCALL
    END

    IF Y.DT.RECEPTION.3 THEN
        Y.DT.FORMA.PAGO = FIELD(R.NEW(TT.TE.LOCAL.REF)<1,L.DT.REC.POS,3>,'*',3)
        param = Y.DT.RECEPTION.3:"::":Y.TT.ID 
        GOSUB DOCALL
    END

    IF Y.DT.RECEPTION.4 THEN
        Y.DT.FORMA.PAGO = FIELD(R.NEW(TT.TE.LOCAL.REF)<1,L.DT.REC.POS,4>,'*',3)
        param = Y.DT.RECEPTION.4:"::":Y.TT.ID 
        GOSUB DOCALL
    END

    RETURN
*----------------------------------------------------------------------------------------------------------
DOCALL:
    IF Y.DT.FORMA.PAGO EQ "Efectivo" THEN
        CALL EB.CALL.JAVA.API(Y.EB.API.ID,param,Y.RESPONSE,Y.CALLJ.ERROR)

        GOSUB PROCESS
        RETURN
    END
    RETURN
*----------------------------------------------------------------------------------------------------------
PROCESS:

    Y.MICRO.VALIDATION = FIELD(Y.RESPONSE,'^^',1)
    Y.MICRO.RESP.CODE = FIELD(Y.MICRO.VALIDATION,'::',1)
    Y.ASM.VALIDATION = FIELD(Y.RESPONSE,'^^',2)
    Y.DESC.ERROR = ""
    Y.FINAL.STATUS = ""
    Y.ID.ASM = ""


    IF Y.CALLJ.ERROR THEN
        BEGIN CASE
        CASE Y.CALLJ.ERROR = 1
            MESSAGE = "Fatal error creating thread."
            Y.STATUS = "PENDIENTE LIQUIDAR"
            
            GOSUB SAVE.LIQ.DT.ITEM.LOG

            TEXT = 'TT.LIQ.DT.ITEM'
            Y.OVERRIDE = R.NEW(TT.TE.OVERRIDE)
            Y.OV.IN = DCOUNT(Y.OVERRIDE,@VM) + 1
            CALL STORE.OVERRIDE(Y.OV.IN)
            
            RETURN
        CASE Y.CALLJ.ERROR = 2
            MESSAGE = "Cannot create JVM."
            Y.STATUS = "PENDIENTE LIQUIDAR"
            
            GOSUB SAVE.LIQ.DT.ITEM.LOG

            TEXT = 'TT.LIQ.DT.ITEM'
            Y.OVERRIDE = R.NEW(TT.TE.OVERRIDE)
            Y.OV.IN = DCOUNT(Y.OVERRIDE,@VM) + 1
            CALL STORE.OVERRIDE(Y.OV.IN)
            
            RETURN
        CASE Y.CALLJ.ERROR = 3
            MESSAGE = "Cannot find JAVA class, please check EB.API Record " : Y.EB.API.ID
            Y.STATUS = "PENDIENTE LIQUIDAR"
            
            GOSUB SAVE.LIQ.DT.ITEM.LOG

            TEXT = 'TT.LIQ.DT.ITEM'
            Y.OVERRIDE = R.NEW(TT.TE.OVERRIDE)
            Y.OV.IN = DCOUNT(Y.OVERRIDE,@VM) + 1
            CALL STORE.OVERRIDE(Y.OV.IN)
            
            RETURN
        CASE Y.CALLJ.ERROR = 4
            MESSAGE = "Unicode conversion error"
            Y.STATUS = "PENDIENTE LIQUIDAR"
            
            GOSUB SAVE.LIQ.DT.ITEM.LOG

            TEXT = 'TT.LIQ.DT.ITEM'
            Y.OVERRIDE = R.NEW(TT.TE.OVERRIDE)
            Y.OV.IN = DCOUNT(Y.OVERRIDE,@VM) + 1
            CALL STORE.OVERRIDE(Y.OV.IN)
            
            RETURN
        CASE Y.CALLJ.ERROR = 5
            MESSAGE = "Cannot find method, please check EB.API Record  " : Y.EB.API.ID
            Y.STATUS = "PENDIENTE LIQUIDAR"
            
            GOSUB SAVE.LIQ.DT.ITEM.LOG

            TEXT = 'TT.LIQ.DT.ITEM'
            Y.OVERRIDE = R.NEW(TT.TE.OVERRIDE)
            Y.OV.IN = DCOUNT(Y.OVERRIDE,@VM) + 1
            CALL STORE.OVERRIDE(Y.OV.IN)
            
            RETURN
        CASE Y.CALLJ.ERROR = 6
            MESSAGE = "Cannot find object constructor"
            Y.STATUS = "PENDIENTE LIQUIDAR"
            
            GOSUB SAVE.LIQ.DT.ITEM.LOG

            TEXT = 'TT.LIQ.DT.ITEM'
            Y.OVERRIDE = R.NEW(TT.TE.OVERRIDE)
            Y.OV.IN = DCOUNT(Y.OVERRIDE,@VM) + 1
            CALL STORE.OVERRIDE(Y.OV.IN)
            
            RETURN
        CASE Y.CALLJ.ERROR = 7
            MESSAGE = "Cannot instantiate object, check all dependencies registrered in CLASSPATH env."
            Y.STATUS = "PENDIENTE LIQUIDAR"
            
            GOSUB SAVE.LIQ.DT.ITEM.LOG

            TEXT = 'TT.LIQ.DT.ITEM'
            Y.OVERRIDE = R.NEW(TT.TE.OVERRIDE)
            Y.OV.IN = DCOUNT(Y.OVERRIDE,@VM) + 1
            CALL STORE.OVERRIDE(Y.OV.IN)

            RETURN
        END CASE
    END
    

    IF FIELD(Y.ASM.VALIDATION,'::',1) EQ '0' THEN
        Y.STATUS = "LIQUIDADO"

        GOSUB SAVE.LIQ.DT.ITEM.LOG

    END ELSE
        Y.STATUS = "PENDIENTE LIQUIDAR"
        Y.EXTRACTO =FIELD(Y.ASM.VALIDATION,'::',2)
        MESSAGE = Y.EXTRACTO

        GOSUB SAVE.LIQ.DT.ITEM.LOG

        TEXT = 'TT.LIQ.DT.ITEM'
        Y.OVERRIDE = R.NEW(TT.TE.OVERRIDE)
        Y.OV.IN = DCOUNT(Y.OVERRIDE,@VM) + 1
        CALL STORE.OVERRIDE(Y.OV.IN)

        RETURN
    END
        
    RETURN

***************************
SAVE.LIQ.DT.ITEM.LOG:
****************************

    Y.TRANS.ID = Y.TT.ID
    Y.APP.NAME = "ST.LAPAP.TB.LIQ.DT.LOG"
    Y.VER.NAME = Y.APP.NAME :",INPUT"
    Y.FUNC = "I"
    Y.PRO.VAL = "PROCESS"
    Y.GTS.CONTROL = ""
    Y.NO.OF.AUTH = ""
    FINAL.OFS = ""
    OPTIONS = ""

    R.ACR = ""
    R.ACR<ST.LAP95.ID.TELLER> = Y.TT.ID
    R.ACR<ST.LAP95.ID.INSTRUMENTO> = R.NEW(TT.TE.LOCAL.REF)<1,L.BOL.DIVISA.POS>
    R.ACR<ST.LAP95.ID.ITEM> = Y.DT.ITEM
    R.ACR<ST.LAP95.STATUS> = Y.STATUS
    R.ACR<ST.LAP95.LOG> = MESSAGE
    R.ACR<ST.LAP95.VERSION> = 'TELLER':PGM.VERSION

    CALL OFS.BUILD.RECORD(Y.APP.NAME,Y.FUNC,Y.PRO.VAL,Y.VER.NAME,Y.GTS.CONTROL,Y.NO.OF.AUTH,Y.TRANS.ID,R.ACR,FINAL.OFS)

    CALL OFS.POST.MESSAGE(FINAL.OFS,'',"LIQ.DT.ITEM",'')

    RETURN

END
