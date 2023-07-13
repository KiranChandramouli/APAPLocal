* @ValidationCode : Mjo3NzQ2NzAxNTY6Q3AxMjUyOjE2ODkyNTQ5NDA3ODY6SGFyaXNodmlrcmFtQzotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 13 Jul 2023 18:59:00
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*    SUBROUTINE REDO.MASSIVE.FILE.PROCESS(Y.FILE.NAME)
SUBROUTINE L.APAP.MASSIVE.FILE.PROCESS(Y.RECORD)
*------------------------------------------------------------
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 13-07-2023     Conversion tool    R22 Auto conversion       FM TO @FM, VM to @VM, SM to @SM, ++ to +=, BP Removed
* 13-07-2023     Harishvikram C   Manual R22 conversion       CALL routine format modified
*-----------------------------------------------------------------------------

    $INSERT I_COMMON                                  ;*R22 Auto conversion - Start
    $INSERT I_EQUATE
    $INSERT I_F.AA.INTEREST
    $INSERT I_F.AA.TERM.AMOUNT
    $INSERT I_F.AA.PAYMENT.SCHEDULE
    $INSERT I_F.AA.OVERDUE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.REDO.MASSIVE.FILE.PATH
    $INSERT I_L.APAP.MASSIVE.FILE.PROCESS.COMMON        ;*R22 Auto conversion - End

    $USING APAP.TAM
    $USING APAP.AA
    GOSUB PROCESS

RETURN

*----------------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------------
* PACS00761324 START
* -----------------------------------------------------------
    Y.FILE.PATH = R.FILE.DETAILS<MASS.FILE.UNPROCESSED.PATH>
    Y.PROCESS.PATH = R.FILE.DETAILS<MASS.FILE.PROCESSED.PATH>
    Y.EXCEPTION.PATH = R.FILE.DETAILS<MASS.FILE.EXCEPTION.PATH>

    J.NUM_ELEMENTOS = ''
    Y.FILE.NAME = ''

    J.NUM_ELEMENTOS = DCOUNT (Y.RECORD,",")
    Y.FILE.NAME = FIELD(Y.RECORD,",",J.NUM_ELEMENTOS)

    CALL OCOMO("Y.FILE.NAME = ":Y.FILE.NAME)

    Y.FILE.TYPE = FIELD(Y.FILE.NAME,'_',1)
    Y.EFFECTIVE.DATE = FIELD(Y.FILE.NAME,'_',2)

*    IF Y.FILE.NAME EQ '' OR Y.FILE.PATH EQ '' THEN
*        CALL OCOMO("File Name or File Path Missing in Param Table")
*        RETURN
*    END

*    OPEN Y.FILE.PATH TO F.FILE.PATH ELSE
*        CALL OCOMO(Y.FILE.NAME:" File not available in path ":Y.FILE.PATH)
*        RETURN
*    END

*    OPEN Y.PROCESS.PATH TO F.PROCESS.PATH ELSE
*        CALL OCOMO(Y.FILE.NAME:" File not available in path ":F.PROCESS.PATH)
*        RETURN
*    END

*    OPEN Y.EXCEPTION.PATH TO F.EXCEPTION.PATH ELSE
*        CALL OCOMO(Y.FILE.NAME:" File not available in path ":F.EXCEPTION.PATH)
*        RETURN
*    END

*    READ Y.REC.ARRAY FROM F.FILE.PATH,Y.FILE.NAME ELSE
*        CALL OCOMO("File could not be read")
*    END
*    CHANGE '"' TO " " IN Y.REC.ARRAY
*    Y.REC.ARR = TRIM(Y.REC.ARRAY,"","A")
*    Y.DOT = CHARX(13)
*    CHANGE Y.DOT TO '' IN Y.REC.ARR

*       GOSUB FILE.PROCESS
    GOSUB GET.CHECK.ARRG

*    REMOVE.CMD="rm -r " : Y.FILE.PATH:"/":Y.FILE.NAME
*   EXECUTE REMOVE.CMD
* -----------------------------------------------------------
* PACS00761324 END

RETURN

*---------------------------------------------------
FILE.PROCESS:
*---------------------------------------------------
* PACS00761324 START
* -----------------------------------------------------------
*    REC.CNT = '0'
*    Y.ARRANGEMENT.REC = '' ; Y.PROCESS.HEADER = '' ; Y.EXCEPTION.HEADER = '' ; Y.REC.EXP.FILE = '' ; Y.REC.PRC.FILE = ''
*    LOOP
*        REMOVE Y.RECORD FROM Y.REC.ARR SETTING Y.POS
*    WHILE Y.RECORD:Y.POS
*        GOSUB GET.CHECK.ARRG
*        REC.CNT = REC.CNT + 1
*    REPEAT
* -----------------------------------------------------------
* PACS00761324 END
RETURN

*---------------------------------------------------
GET.CHECK.ARRG:
*---------------------------------------------------

    Y.ARG.ID  = FIELD(Y.RECORD,',',1)
    CALL OCOMO("Y.ARG.ID = ":Y.ARG.ID)
    IF Y.ARG.ID EQ '' THEN
        RETURN
    END

    IF NUM(Y.ARG.ID) ELSE
* PACS00761324 START
* -----------------------------------------------------------
*        IF Y.ARG.ID EQ "ID_PRESTAMO" THEN
*            Y.PROCESS.HEADER = Y.RECORD
*            Y.EXCEPTION.HEADER = Y.RECORD
*            Y.PROCESS.HEADER = "ID_PRESTAMO,ID_CLIENTE,TIPO_OPERACION,TASA_MARGEN,TASA_INT_PROPUESTA,NOMBRE_ARCHIVO"
*            Y.EXCEPTION.HEADER = "ID_PRESTAMO,ID_CLIENTE,TIPO_OPERACION,TASA_MARGEN,TASA_INT_PROPUESTA,NOMBRE_ARCHIVO"
*            Y.REC.PRC.FILE<-1> = Y.PROCESS.HEADER
*            Y.REC.EXP.FILE<-1> = Y.EXCEPTION.HEADER
*        END
* -----------------------------------------------------------
* PACS00761324 END
        RETURN
    END

    Y.ARRANGEMENT.REC = Y.RECORD

    OFS.STRING = ''
    ACC.ID = FIELD(Y.ARRANGEMENT.REC,',',1)
    IN.ARR.ID = ''
*    CALL REDO.CONVERT.ACCOUNT(ACC.ID,IN.ARR.ID,OUT.ID,ERR.TEXT)
    APAP.TAM.redoConvertAccount(ACC.ID,IN.ARR.ID,OUT.ID,ERR.TEXT)          ;*Manual R22 conversion
    ARR.ID = OUT.ID
    GOSUB CHECK.OD.STATUS
*    IF Y.OVR.STATUS.1 EQ 'CUR' AND Y.OVR.STATUS.2 EQ 'CUR' THEN
    GOSUB PROCESS.OFS
    J.ID = ACC.ID:"_":C$T24.SESSION.NO
    CALL F.WRITE(FN.REDO.MASSIVE.CONCAT,J.ID,Y.RECORD)
    CALL OCOMO("REGISTRO PROCESADO: ":Y.RECORD)
*    END ELSE
*        J.ID = ACC.ID:"_":C$T24.SESSION.NO
*        CALL F.WRITE(FN.REDO.MASSIVE.CONCAT.EX,J.ID,Y.RECORD)
*        CALL OCOMO("REGISTRO EN EXCEPTION: ":Y.RECORD)
*    END

RETURN

*---------------------------------------------------
CHECK.OD.STATUS:
*---------------------------------------------------

    CALL F.READ(FN.ACCOUNT,ACC.ID,R.ACCOUNT,F.ACCOUNT,ACC.ERR)

    Y.OVR.STATUS.1 = R.ACCOUNT<AC.LOCAL.REF,Y.POS.OVR.1>
    Y.OVR.STATUS.2 = R.ACCOUNT<AC.LOCAL.REF,Y.POS.OVR.2>

RETURN

*---------------------------------------------------
PROCESS.OFS:
*---------------------------------------------------

    PROP.NAME='PRINCIPAL'     ;* Interest Property to obtain
*    CALL REDO.GET.INTEREST.PROPERTY(ARR.ID,PROP.NAME,OUT.PROP,ERR)
    APAP.TAM.redoGetInterestProperty(ARR.ID,PROP.NAME,OUT.PROP,ERR)           ;*Manual R22 conversion
    Y.PRIN.PROP  = OUT.PROP   ;* This variable hold the value of principal interest property


    PROP.NAME='PENALTY'       ;* Interest Property to obtain
*    CALL REDO.GET.INTEREST.PROPERTY(ARR.ID,PROP.NAME,OUT.PROP,ERR)
    APAP.TAM.redoGetInterestProperty(ARR.ID,PROP.NAME,OUT.PROP,ERR)           ;*Manual R22 conversion
    Y.PENAL.PROP = OUT.PROP   ;* This variable hold the value of penalty interest property

    Y.MARGIN.OPER   = FIELD(Y.ARRANGEMENT.REC,',',3)
    Y.MARGIN.RATE   = FIELD(Y.ARRANGEMENT.REC,',',4)
    Y.INTEREST.RATE = FIELD(Y.ARRANGEMENT.REC,',',5)

    IF Y.MARGIN.OPER NE '' AND Y.MARGIN.RATE NE '' THEN
        GOSUB ADD.MARGIN.RATE
    END
    IF Y.INTEREST.RATE NE '' THEN
        GOSUB ADD.INT.RATE
    END

RETURN

*---------------------------------------------------
ADD.MARGIN.RATE:
*---------------------------------------------------
    GOSUB GET.PRINCIPAL.PROPERTY
    GOSUB GET.PENALTY.PROPERTY
    IF Y.FILE.TYPE EQ 'MASSIVE' OR Y.FILE.TYPE EQ 'EXTRACT' THEN
        GOSUB BUILD.MARGIN.OFS
    END
    IF FIELD(Y.FILE.TYPE,".",1) EQ 'REPLACE' THEN
        IF FIELD(Y.FILE.TYPE,".",2) EQ 'REPLACE' THEN
            GOSUB BUILD.MARGIN.REPLACE
        END
        IF FIELD(Y.FILE.TYPE,".",2) EQ 'SUMUP' THEN
            GOSUB BUILD.MARGIN.OFS
        END

    END

RETURN

*---------------------------------------------------
ADD.INT.RATE:
*---------------------------------------------------
    GOSUB GET.PRINCIPAL.PROPERTY
    GOSUB GET.PENALTY.PROPERTY
    GOSUB BUILD.RATE.OFS

RETURN

*---------------------------------------------------
BUILD.MARGIN.REPLACE:
*---------------------------------------------------
    Y.PRIN.RATE.ARRAY.OFS = ''
    Y.PENAL.RATE.ARRAY.OFS = ''
    Y.PRIN.RATE.ARRAY = ''
    Y.PENAL.RATE.ARRAY = ''

    Y.PRIN.RATE.ARRAY<AA.INT.FIXED.RATE> = FIELD(R.PRINCIPAL.PROPERTY,@FM,AA.INT.FIXED.RATE,11)
    Y.PENAL.RATE.ARRAY<AA.INT.FIXED.RATE> = FIELD(R.PENALTY.PROPERTY,@FM,AA.INT.FIXED.RATE,11)

    Y.FIXED.RATE = Y.PRIN.RATE.ARRAY<AA.INT.FIXED.RATE>
    Y.FIXED.CNT = DCOUNT(Y.FIXED.RATE,@VM)
    Y.VAR1 = 1
    LOOP
    WHILE Y.VAR1 LE Y.FIXED.CNT
        Y.PRIN.RATE.ARRAY.OFS<AA.INT.MARGIN.TYPE,Y.VAR1,1> = 'SINGLE'
        Y.PRIN.RATE.ARRAY.OFS<AA.INT.MARGIN.OPER,Y.VAR1,1> = Y.MARGIN.OPER
        Y.PRIN.RATE.ARRAY.OFS<AA.INT.MARGIN.RATE,Y.VAR1,1> = Y.MARGIN.RATE
        Y.VAR1 += 1
    REPEAT

    Y.FIXED.RATE = Y.PENAL.RATE.ARRAY<AA.INT.FIXED.RATE>
    Y.FIXED.CNT = DCOUNT(Y.FIXED.RATE,@VM)
    Y.VAR1 = 1
    LOOP
    WHILE Y.VAR1 LE Y.FIXED.CNT
        Y.PENAL.RATE.ARRAY.OFS<AA.INT.MARGIN.TYPE,Y.VAR1,1> = 'SINGLE'
        Y.PENAL.RATE.ARRAY.OFS<AA.INT.MARGIN.OPER,Y.VAR1,1> = Y.MARGIN.OPER
        Y.PENAL.RATE.ARRAY.OFS<AA.INT.MARGIN.RATE,Y.VAR1,1> = Y.MARGIN.RATE
        Y.VAR1 += 1
    REPEAT

    GOSUB POST.OFS

RETURN

*---------------------------------------------------
BUILD.MARGIN.OFS:
*---------------------------------------------------
    Y.PRIN.RATE.ARRAY.OFS = ''
    Y.PENAL.RATE.ARRAY.OFS = ''
    Y.PRIN.RATE.ARRAY = ''
    Y.PENAL.RATE.ARRAY = ''
    Y.PRIN.RATE.ARRAY<AA.INT.FIXED.RATE> = FIELD(R.PRINCIPAL.PROPERTY,@FM,AA.INT.FIXED.RATE,11)
    Y.PENAL.RATE.ARRAY<AA.INT.FIXED.RATE> = FIELD(R.PENALTY.PROPERTY,@FM,AA.INT.FIXED.RATE,11)

    Y.FIXED.RATE = Y.PRIN.RATE.ARRAY<AA.INT.FIXED.RATE>
    Y.FIXED.CNT = DCOUNT(Y.FIXED.RATE,@VM)
    Y.CNT1 = 1
    LOOP
    WHILE Y.CNT1 LE Y.FIXED.CNT
        Y.FINAL.MARGIN.RATE = 0
        Y.SUB.CNT = DCOUNT(Y.PRIN.RATE.ARRAY<AA.INT.MARGIN.RATE,Y.CNT1>,@SM)
        Y.CNT2 = 1
        LOOP
        WHILE Y.CNT2 LE Y.SUB.CNT
            IF Y.PRIN.RATE.ARRAY<AA.INT.MARGIN.OPER,Y.CNT1,Y.CNT2> EQ 'ADD' THEN
                Y.FINAL.MARGIN.RATE += Y.PRIN.RATE.ARRAY<AA.INT.MARGIN.RATE,Y.CNT1,Y.CNT2>
            END
            IF Y.PRIN.RATE.ARRAY<AA.INT.MARGIN.OPER,Y.CNT1,Y.CNT2> EQ 'SUB' THEN
                Y.FINAL.MARGIN.RATE -= Y.PRIN.RATE.ARRAY<AA.INT.MARGIN.RATE,Y.CNT1,Y.CNT2>
            END
            Y.CNT2 += 1
        REPEAT

        IF Y.MARGIN.OPER EQ 'ADD' THEN
            Y.FINAL.MARGIN.RATE+=Y.MARGIN.RATE
        END
        IF Y.MARGIN.OPER EQ 'SUB' THEN
            Y.FINAL.MARGIN.RATE-=Y.MARGIN.RATE
        END
        Y.PRIN.RATE.ARRAY.OFS<AA.INT.MARGIN.TYPE,Y.CNT1> = 'SINGLE'
        IF Y.FINAL.MARGIN.RATE GE 0 THEN
            Y.PRIN.RATE.ARRAY.OFS<AA.INT.MARGIN.OPER,Y.CNT1> = 'ADD'
        END
        IF Y.FINAL.MARGIN.RATE LT 0 THEN
            Y.PRIN.RATE.ARRAY.OFS<AA.INT.MARGIN.OPER,Y.CNT1> = 'SUB'
        END
        Y.PRIN.RATE.ARRAY.OFS<AA.INT.MARGIN.RATE,Y.CNT1> = ABS(Y.FINAL.MARGIN.RATE)
        Y.CNT1 += 1
    REPEAT

    Y.FIXED.RATE = Y.PENAL.RATE.ARRAY<AA.INT.FIXED.RATE>
    Y.FIXED.CNT = DCOUNT(Y.FIXED.RATE,@VM)
    Y.CNT1 = 1
    LOOP
    WHILE Y.CNT1 LE Y.FIXED.CNT

        Y.FINAL.MARGIN.RATE = 0
        Y.SUB.CNT = DCOUNT(Y.PENAL.RATE.ARRAY<AA.INT.MARGIN.RATE,Y.CNT1>,@SM)
        Y.CNT2 = 1
        LOOP
        WHILE Y.CNT2 LE Y.SUB.CNT
            IF Y.PENAL.RATE.ARRAY<AA.INT.MARGIN.OPER,Y.CNT1,Y.CNT2> EQ 'ADD' THEN
                Y.FINAL.MARGIN.RATE += Y.PENAL.RATE.ARRAY<AA.INT.MARGIN.RATE,Y.CNT1,Y.CNT2>
            END
            IF Y.PENAL.RATE.ARRAY<AA.INT.MARGIN.OPER,Y.CNT1,Y.CNT2> EQ 'SUB' THEN
                Y.FINAL.MARGIN.RATE -= Y.PENAL.RATE.ARRAY<AA.INT.MARGIN.RATE,Y.CNT1,Y.CNT2>
            END
            Y.CNT2 += 1
        REPEAT
        IF Y.MARGIN.OPER EQ 'ADD' THEN
            Y.FINAL.MARGIN.RATE+=Y.MARGIN.RATE
        END
        IF Y.MARGIN.OPER EQ 'SUB' THEN
            Y.FINAL.MARGIN.RATE-=Y.MARGIN.RATE
        END
        Y.PENAL.RATE.ARRAY.OFS<AA.INT.MARGIN.TYPE,Y.CNT1> = 'SINGLE'
        IF Y.FINAL.MARGIN.RATE GE 0 THEN
            Y.PENAL.RATE.ARRAY.OFS<AA.INT.MARGIN.OPER,Y.CNT1> = 'ADD'
        END
        IF Y.FINAL.MARGIN.RATE LT 0 THEN
            Y.PENAL.RATE.ARRAY.OFS<AA.INT.MARGIN.OPER,Y.CNT1> = 'SUB'
        END
        Y.PENAL.RATE.ARRAY.OFS<AA.INT.MARGIN.RATE,Y.CNT1> = ABS(Y.FINAL.MARGIN.RATE)
        Y.CNT1 += 1
    REPEAT
    IF Y.FILE.TYPE EQ 'MASSIVE' OR Y.FILE.TYPE EQ 'EXTRACT' THEN
        GOSUB PROCESS.REVIEW.DATES
    END
    GOSUB POST.OFS

RETURN

*---------------------------------------------------
PROCESS.REVIEW.DATES:
*---------------------------------------------------
    Y.REVIEW.FREQ = R.PRINCIPAL.PROPERTY<AA.INT.LOCAL.REF,POS.L.AA.RT.RV.FREQ>
    IF Y.REVIEW.FREQ THEN
        GOSUB GET.MATURITY.DATE
*Y.OUT.DATE = TODAY
*ADV.MONTH = Y.REVIEW.FREQ
*-------------------PACS00136838---------------------
*CALL CFQ
*CALL CALENDAR.DAY(Y.OUT.DATE,'+',ADV.MONTH)
*Y.OUT.DATE = Y.FIRST.REV.DATE
*COMI = Y.REVIEW.FREQ
*CALL CFQ
*Y.OUT.DATE = COMI
*Y.NEXT.DATE = Y.OUT.DATE[1,8]
*Y.NEXT.DATE = ADV.MONTH[1,8]
*-------------------PACS00136838---------------------
*-------------------PACS00165067---------------------
*Y.DATE = TODAY
        IF LEN(Y.EFFECTIVE.DATE) NE 8 THEN        ;* In Case if the date is not proper in file name.
            Y.DATE = TODAY
        END ELSE
            Y.DATE = Y.EFFECTIVE.DATE
        END
        FREQ   = Y.REVIEW.FREQ
*        CALL REDO.GET.NEXT.CYCLEDATE(ARR.ID,FREQ,Y.DATE,Y.OUT.DATE)
        APAP.TAM.redoGetNextCycledate(ARR.ID,FREQ,Y.DATE,Y.OUT.DATE)        ;*Manual R22 conversion
*-------------------PACS00165067---------------------
        Y.NEXT.DATE = Y.OUT.DATE
        IF Y.NEXT.DATE GE Y.MAT.DATE THEN
            Y.NEXT.DATE = TODAY
        END
        Y.PRIN.RATE.ARRAY.OFS<AA.INT.LOCAL.REF,POS.L.AA.NXT.REV.DT>  = Y.NEXT.DATE
*       Y.PRIN.RATE.ARRAY.OFS<AA.INT.LOCAL.REF,POS.L.AA.RT.RV.FREQ>  = Y.NEXT.DATE:Y.REVIEW.FREQ[9,LEN(Y.REVIEW.FREQ)-8]
        Y.PENAL.RATE.ARRAY.OFS<AA.INT.LOCAL.REF,POS.L.AA.NXT.REV.DT> = Y.NEXT.DATE
*        Y.PENAL.RATE.ARRAY.OFS<AA.INT.LOCAL.REF,POS.L.AA.RT.RV.FREQ> = Y.NEXT.DATE:Y.REVIEW.FREQ[9,LEN(Y.REVIEW.FREQ)-8]


    END
    Y.PRIN.RATE.ARRAY.OFS<AA.INT.LOCAL.REF,POS.L.AA.LST.REV.DT>  = Y.EFFECTIVE.DATE
    Y.PENAL.RATE.ARRAY.OFS<AA.INT.LOCAL.REF,POS.L.AA.LST.REV.DT> = Y.EFFECTIVE.DATE

RETURN

*---------------------------------------------------
BUILD.RATE.OFS:
*---------------------------------------------------
    Y.PRIN.RATE.ARRAY.OFS = ''
    Y.PENAL.RATE.ARRAY.OFS = ''
    Y.PRIN.RATE.ARRAY = ''
    Y.PENAL.RATE.ARRAY = ''
    Y.PRIN.RATE.ARRAY<AA.INT.FIXED.RATE> = FIELD(R.PRINCIPAL.PROPERTY,@FM,AA.INT.FIXED.RATE,11)
    Y.PENAL.RATE.ARRAY<AA.INT.FIXED.RATE> = FIELD(R.PENALTY.PROPERTY,@FM,AA.INT.FIXED.RATE,11)

    Y.FIXED.RATE = Y.PRIN.RATE.ARRAY<AA.INT.FIXED.RATE>
    Y.FIXED.CNT = DCOUNT(Y.FIXED.RATE,@VM)
    Y.VAR1 = 1
    LOOP
    WHILE Y.VAR1 LE Y.FIXED.CNT
        Y.PRIN.RATE.ARRAY.OFS<AA.INT.FIXED.RATE,Y.VAR1> = Y.INTEREST.RATE

        Y.MARGIN.TYPE = Y.PRIN.RATE.ARRAY<AA.INT.MARGIN.TYPE,Y.VAR1>
        Y.MARGIN.TYPE.CNT = DCOUNT(Y.MARGIN.TYPE,@SM)
        Y.VAR2 = 1
        LOOP
        WHILE Y.VAR2 LE Y.MARGIN.TYPE.CNT
            Y.PRIN.RATE.ARRAY.OFS<AA.INT.MARGIN.RATE,Y.VAR1,Y.VAR2> = 0
            Y.VAR2 += 1
        REPEAT
        Y.VAR1 += 1
    REPEAT

    Y.FIXED.RATE = Y.PENAL.RATE.ARRAY<AA.INT.FIXED.RATE>
    Y.FIXED.CNT = DCOUNT(Y.FIXED.RATE,@VM)
    Y.VAR1 = 1
    LOOP
    WHILE Y.VAR1 LE Y.FIXED.CNT
        Y.PENAL.RATE.ARRAY.OFS<AA.INT.FIXED.RATE,Y.VAR1> = Y.INTEREST.RATE

        Y.MARGIN.TYPE = Y.PENAL.RATE.ARRAY<AA.INT.MARGIN.TYPE,Y.VAR1>
        Y.MARGIN.TYPE.CNT = DCOUNT(Y.MARGIN.TYPE,@SM)
        Y.VAR2 = 1
        LOOP
        WHILE Y.VAR2 LE Y.MARGIN.TYPE.CNT
            Y.PENAL.RATE.ARRAY.OFS<AA.INT.MARGIN.RATE,Y.VAR1,Y.VAR2> = 0
            Y.VAR2 += 1
        REPEAT

        Y.VAR1 += 1
    REPEAT
*IF Y.FILE.TYPE NE 'REPLACE' THEN
    IF Y.FILE.TYPE EQ 'MASSIVE' OR Y.FILE.TYPE EQ 'EXTRACT' THEN
        GOSUB PROCESS.REVIEW.DATES
    END
    GOSUB POST.OFS

RETURN

*---------------------------------------------------
POST.OFS:
*---------------------------------------------------
    Y.ACT.PROP=''
    Y.ACT.PROP<1> = Y.PRIN.PROP
    Y.ACT.PROP<2> = "LENDING-CHANGE-":Y.PRIN.PROP
    OFS.STRING.FINAL = ''
    OFS.SRC = 'AA.INT.UPDATE'
    OPTIONS = ''
*    CALL REDO.AA.BUILD.OFS(ARR.ID,Y.PRIN.RATE.ARRAY.OFS,Y.ACT.PROP,OFS.STRING.PRIN)
    APAP.AA.redoAaBuildOfs(ARR.ID,Y.PRIN.RATE.ARRAY.OFS,Y.ACT.PROP,OFS.STRING.PRIN)       ;*Manual R22 conversion
    OFS.STRING.PRIN:="EFFECTIVE.DATE:1:1=":Y.EFFECTIVE.DATE
* PACS00617141 - S
    CALL OCOMO(" PACS00617141 Change principal interest for via POST - ":ARR.ID:" - START")
    OFS.RESP   = ""; TXN.COMMIT = ""
    CALL OFS.CALL.BULK.MANAGER(OFS.SRC, OFS.STRING.PRIN, OFS.RESP, TXN.COMMIT)
    CALL OCOMO(" END MESSAGE- ":ARR.ID:" - END RESP - ":OFS.RESP)

    Y.ACT.PROP=''
    Y.ACT.PROP<1> = Y.PENAL.PROP
    Y.ACT.PROP<2> = "LENDING-CHANGE-":Y.PENAL.PROP
*OFS.STRING.FINAL = ''
*    CALL REDO.AA.BUILD.OFS(ARR.ID,Y.PENAL.RATE.ARRAY.OFS,Y.ACT.PROP,OFS.STRING.PENAL)
    APAP.AA.redoAaBuildOfs(ARR.ID,Y.PENAL.RATE.ARRAY.OFS,Y.ACT.PROP,OFS.STRING.PENAL)       ;*Manual R22 conversion
    OFS.STRING.PENAL:="EFFECTIVE.DATE:1:1=":Y.EFFECTIVE.DATE

*    OFS.STRING.FINAL= OFS.STRING.PRIN:FM:OFS.STRING.PENAL

*    CALL OFS.POST.MESSAGE(OFS.STRING.FINAL,OFS.MSG.ID,OFS.SRC,OPTIONS)
    OFS.RESP   = ""; TXN.COMMIT = ""
    CALL OCOMO(" PACS00617141 Change penalti interest for via POST - ":ARR.ID:" - START")
    CALL OFS.CALL.BULK.MANAGER(OFS.SRC, OFS.STRING.PENAL, OFS.RESP, TXN.COMMIT)
    CALL OCOMO(" END MESSAGE- ":ARR.ID:" - END RESP - ":OFS.RESP)

* PACS00617141 - E

RETURN

*---------------------------------------------------
GET.PRINCIPAL.PROPERTY:
*---------------------------------------------------
    Y.ARRG.ID = ARR.ID
    PROPERTY.CLASS = 'INTEREST'
    PROPERTY = Y.PRIN.PROP
    EFF.DATE = TODAY
    ERR.MSG = ''
    R.PRINCIPAL.PROPERTY = ''
*    CALL REDO.CRR.GET.CONDITIONS(Y.ARRG.ID,EFF.DATE,PROPERTY.CLASS,PROPERTY,R.PRINCIPAL.PROPERTY,ERR.MSG)
    APAP.AA.redoCrrGetConditions(Y.ARRG.ID,EFF.DATE,PROPERTY.CLASS,PROPERTY,R.PRINCIPAL.PROPERTY,ERR.MSG)      ;*Manual R22 conversion

RETURN

*---------------------------------------------------
GET.PENALTY.PROPERTY:
*---------------------------------------------------
    Y.ARRG.ID = ARR.ID
    PROPERTY.CLASS = 'INTEREST'
    PROPERTY = Y.PENAL.PROP
    EFF.DATE = TODAY
    ERR.MSG = ''
    R.PENALTY.PROPERTY = ''
*    CALL REDO.CRR.GET.CONDITIONS(Y.ARRG.ID,EFF.DATE,PROPERTY.CLASS,PROPERTY,R.PENALTY.PROPERTY,ERR.MSG)
    APAP.AA.redoCrrGetConditions(Y.ARRG.ID,EFF.DATE,PROPERTY.CLASS,PROPERTY,R.PRINCIPAL.PROPERTY,ERR.MSG)      ;*Manual R22 conversion
RETURN

*---------------------------------------------------
GET.MATURITY.DATE:
*---------------------------------------------------
    Y.ARRG.ID = ARR.ID
    PROPERTY.CLASS = 'TERM.AMOUNT'
    PROPERTY = ''
    EFF.DATE = TODAY
    ERR.MSG = ''
    R.TERM.PROPERTY = ''
*    CALL REDO.CRR.GET.CONDITIONS(Y.ARRG.ID,EFF.DATE,PROPERTY.CLASS,PROPERTY,R.TERM.PROPERTY,ERR.MSG)
    APAP.AA.redoCrrGetConditions(Y.ARRG.ID,EFF.DATE,PROPERTY.CLASS,PROPERTY,R.PRINCIPAL.PROPERTY,ERR.MSG)      ;*Manual R22 conversion
    Y.MAT.DATE = R.TERM.PROPERTY<AA.AMT.MATURITY.DATE>

RETURN
END
