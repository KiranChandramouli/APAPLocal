* @ValidationCode : MjotMTIwMjcyNzYxMDpDcDEyNTI6MTY4NDg1Njg3Nzk0MTpJVFNTOi0xOi0xOjM4MTE6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 May 2023 21:17:57
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 3811
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.DRREG
*
*----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                   DESCRIPTION
*10-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   VM to @VM , FM to @FM , CONVERT into CHANGE
*10-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION CALL ROUTINE  FORMAT CAN BE MODIFIED
*----------------------------------------------------------------------------------------




*----------------------------------------------------------------------------
SUBROUTINE DR.REG.RIEN6.AZ.EXT
*----------------------------------------------------------------------------
* Routine to extract AZ contracts for REIN6. Part of the performance changes
* moved the RIEN6 from TFR to T24.
*
*----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE

    $INSERT I_F.DATES
    $INSERT I_F.CATEGORY
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AZ.ACCOUNT
*Tus start
    $INSERT I_F.EB.CONTRACT.BALANCES ;*Tus end

    $INSERT I_F.DR.REGREP.PARAM
*Tus start
    GOSUB MULTI.GET.LOC.REF.DEFINE;*Tus end

    GOSUB INIT.PARA

    IF PROCESS.GO.AHEAD THEN
        GOSUB SEL.PARA
        GOSUB PRINT.HEADER
        GOSUB PROCESS.PARA
        CLOSESEQ F.REGREPORT
    END

RETURN


*----------------------------------------------------------------------------
PROCESS.PARA:
*----------------------------------------------------------------------------
*
    LOOP
        REMOVE AZ.ID FROM AZ.ID.LIST SETTING POS
    WHILE AZ.ID:POS
* READ R.AZ.ACCOUNT FROM F.AZ.ACCOUNT,AZ.ID THEN ;*Tus Start
        CALL F.READ(FN.AZ.ACCOUNT,AZ.ID,R.AZ.ACCOUNT,F.AZ.ACCOUNT,R.AZ.ACCOUNT.ERR)
        IF R.AZ.ACCOUNT THEN ;* Tus End

* READ R.ACCOUNT FROM F.ACCOUNT, AZ.ID ELSE NULL ;*Tus Start
            CALL F.READ(FN.ACCOUNT,AZ.ID,R.ACCOUNT,F.ACCOUNT,R.ACCOUNT.ERR);*Tus End
            REP.LINE = ''
            REP.LINE<1> = FMT(EXTR.DATE,'8L')

            Y.AZ.SHA1.CODE = '' ; Y.AZ.SHA1.CODE = R.AZ.ACCOUNT<AZ.LOCAL.REF, L.AZ.SHA1.CODE.POS>
            REP.LINE<2> = FMT(Y.AZ.SHA1.CODE, '60L')

            GOSUB GET.CUSTOMER.INFO
            REP.LINE<3> = FMT(CUSTOMER.CODE, '30L')

            REP.LINE<4> = FMT('A', '10L')
            REP.LINE<5> = FMT('A', '5L')


*** CHECK WITH ERIKA ON FIELD 6 ***** REPLACE VALUE 'ABCD' WITH PROPER VALUE AFTER GET THE REPLY FROM ERIKA
            LOCATE 'ABCD' IN R.TABLE.J<DR.REG.T24.FLD1.VALUE,1> SETTING J.POS THEN
                Y.INSTR.TYPE = R.TABLE.J<DR.REG.REG.TAB.VALUE><1,J.POS>
                REP.LINE<6> = FMT(Y.INSTR.TYPE, '3L')
            END ELSE
                REP.LINE<6> = FMT('', '3L')
            END

*** CHECK WITH ERIKA ON FIELD 7 ***
            Y.AZ.CATEG = '' ; Y.AZ.CATEG = R.AZ.ACCOUNT<AZ.CATEGORY>
            LOCATE Y.AZ.CATEG IN R.TABLE.PRODUCTOS<DR.REG.T24.FLD1.VALUE,1> SETTING RP.POS THEN
                REP.LINE<7> = FMT(R.TABLE.PRODUCTOS<DR.REG.REG.TAB.VALUE><1,RP.POS> :'0', '10L')
            END ELSE
                REP.LINE<7> = FMT('','10L')
            END

            Y.CREATE.DATE = '' ; Y.CREATE.DATE = R.AZ.ACCOUNT<AZ.CREATE.DATE>
            Y.CREATE.DATE = Y.CREATE.DATE[7,2] :'/': Y.CREATE.DATE[5,2] :'/': Y.CREATE.DATE[1,4]
            REP.LINE<8> = FMT(Y.CREATE.DATE, '10L')


            VAL.DATE = '' ; VAL.DATE = R.AZ.ACCOUNT<AZ.VALUE.DATE>
            MAT.DATE = '' ; MAT.DATE = R.AZ.ACCOUNT<AZ.MATURITY.DATE>
            TERM.IN.DAYS = '' ; CALL CDD('', VAL.DATE, MAT.DATE, TERM.IN.DAYS)

            REP.LINE<9> = FMT(TERM.IN.DAYS, 'R%5')


            MATURITY.DATE = '' ; MATURITY.DATE = R.AZ.ACCOUNT<AZ.MATURITY.DATE>
            REP.LINE<10> = MATURITY.DATE[7,2]:'/':MATURITY.DATE[5,2]:'/':MATURITY.DATE[1,4]


            Y.ROLLOVER.TERM = '' ; Y.ROLLOVER.TERM = R.AZ.ACCOUNT<AZ.ROLLOVER.TERM>
            IF Y.ROLLOVER.TERM AND (Y.ROLLOVER.TERM MATCHES '...D') THEN
                REP.LINE<11> = FMT(Y.ROLLOVER.TERM, 'R%5')
            END ELSE
                REP.LINE<11> = FMT('0', 'R%5')
            END


            REP.LINE<12> = FMT(R.AZ.ACCOUNT<AZ.ORIG.PRINCIPAL>, 'R2%15')
            REP.LINE<13> = FMT('0', 'R4%8')

            REP.LINE<14> = FMT(R.AZ.ACCOUNT<AZ.INTEREST.RATE>, 'R2%6')
            REP.LINE<15> = FMT(R.AZ.ACCOUNT<AZ.INTEREST.RATE>, 'R2%6')

*** Check with ERIKA / FIELD 16 ***
            REP.LINE<16> = FMT('5', '2L')

            GOSUB GET.AZ.INT.AMOUNT ;*** CHECK WITH REJETH ON BALANCE.TYPE
            REP.LINE<17> = FMT(ECB.BALANCE, 'R4%15')

            Y.PI.INT = ''
            GOSUB GET.PI.INT.FLAG
            REP.LINE<18> = FMT(Y.PI.INT, 'R%2')

*** Check with ERIKA / FIELD 19 & 20
            REP.LINE<19> = '2'
            REP.LINE<20> = '2'

*** Check with torres about FIELD 21
            REP.LINE<21> = FMT('','10L')

*** Check with ERIKA*** Not clear FIELD 22 & 23
            REP.LINE<22> = FMT('', '30L')
            REP.LINE<23> = FMT('', '3L')

            REP.LINE<24> = R.CUSTOMER<EB.CUS.LOCAL.REF><1,TIPO.CL.POS>


            IF R.AZ.ACCOUNT<AZ.MATURITY.DATE> THEN
                REP.LINE<25> = R.AZ.ACCOUNT<AZ.MATURITY.DATE>
            END ELSE
                REP.LINE<25> = ''
            END


            REP.LINE<26> = FMT('0.00', '15R4%')

            Y.AZ.CCY = '' ; Y.AZ.CCY = R.AZ.ACCOUNT<AZ.CURRENCY> ; CCY.POS = ''
            LOCATE Y.AZ.CCY IN R.TABLE.E<DR.REG.T24.FLD1.VALUE, 1> SETTING CCY.POS THEN
                REP.LINE<27> = R.TABLE.E<DR.REG.REG.TAB.VALUE><1,CCY.POS>
            END ELSE
                REP.LINE<27> = '0'
            END

*** Check with ERIKA - Field 28, 29 & 30
            REP.LINE<28> = ''
            REP.LINE<29> = ''
            REP.LINE<30> = '0'


            AZ.CU.REL.CODE = '' ; AZ.CU.REL.CODE = R.CUSTOMER<EB.CUS.RELATION.CODE> ; REL.POS = ''
            LOCATE AZ.CU.REL.CODE IN R.TABLE.REL.CODES<DR.REG.T24.FLD1.VALUE,1> SETTING REL.POS THEN
                REP.LINE<31> = R.TABLE.REL.CODES<DR.REG.REG.TAB.VALUE><1,REL.POS>
            END ELSE
                REP.LINE<31> = ''
            END

            REP.LINE<32> = R.CUSTOMER<EB.CUS.INDUSTRY>

            BEGIN CASE
                CASE R.AZ.ACCOUNT<AZ.LOCAL.REF><1,STATUS2.POS> EQ 'GARNISHMENT'
                    REP.LINE<33> = 'E'

                CASE R.AZ.ACCOUNT<AZ.LOCAL.REF><1,STATUS2.POS> EQ 'GUARANTEE.STATUS'
                    REP.LINE<33> = 'G'

                CASE R.AZ.ACCOUNT<AZ.LOCAL.REF><1,STATUS1.POS> EQ 'ACTIVE'
                    REP.LINE<33> = 'A'

                CASE R.AZ.ACCOUNT<AZ.LOCAL.REF><1,STATUS1.POS> EQ 'ABANDONED'
                    REP.LINE<33> = 'B'

                CASE R.AZ.ACCOUNT<AZ.LOCAL.REF><1,STATUS1.POS> MATCHES '6MINACTIVE':@VM:'3YINACTIVE'
                    REP.LINE<33> = 'I'

                CASE 1
                    REP.LINE<33> = ''
            END CASE

            Y.AZ.CO.CODE = '' ; Y.AZ.CO.CODE = R.AZ.ACCOUNT<AZ.CO.CODE> ; CO.POS = ''
            LOCATE Y.AZ.CO.CODE IN R.TABLE.LOCATION<DR.REG.T24.FLD1.VALUE,1> SETTING CO.POS THEN
                REP.LINE<34> = R.TABLE.LOCATION<DR.REG.REG.TAB.VALUE><1,CO.POS>
            END ELSE
                REP.LINE<34> = ''
            END


*** CHECK WITH ERIKA ON FIELD 35 about TABLE.O mapping in PARAM table ; **** REPLACE VALUE 'ABCD' WITH PROPER VALUE AFTER GET THE REPLY FROM ERIKA
            LOCATE 'ABCD' IN R.TABLE.O<DR.REG.T24.FLD1.VALUE,1> SETTING O.POS THEN
                REP.LINE<35> = R.TABLE.O<DR.REG.REG.TAB.VALUE><1,O.POS>
            END ELSE
                REP.LINE<35> = ''
            END


            GOSUB GET.INT.REINVEST.AMT
            REP.LINE<36> = FMT(Y.REINVEST.AMOUNT, '15R2%')


            IF R.ACCOUNT<AC.LOCAL.REF><1, AC.REINVESTED.POS> 'YES' THEN
                L.ASSET.TYPE = 'CREDIT':@FM:'50000':@FM:'50001':@FM:'50010'
                ACCT.ENT.ID = R.ACCOUNT<AC.INTEREST.LIQU.ACCT>
                GOSUB GET.ACCOUNTING.HEAD
                REP.LINE<37> = FMT(V.ACCOUNTING.HEAD, '30L')
            END ELSE
                REP.LINE<37> = ''
            END


            L.ASSET.TYPE = 'CREDIT':@FM:'50000':@FM:'50001':@FM:'50010'
            ACCT.ENT.ID = AZ.ID
            GOSUB GET.ACCOUNTING.HEAD
            REP.LINE<38> = FMT(V.ACCOUNTING.HEAD, '30L')


            CHANGE @FM TO ',' IN REP.LINE ;*R22 AUTO CODE CONVERSION

            WRITESEQ REP.LINE TO F.REGREPORT ELSE PRINT 'ERROR ON WRITE'
        END
    REPEAT

RETURN

*----------------------------------------------------------------------------
GET.CUSTOMER.INFO:
*----------------------------------------------------------------------------
*
    CUST.ID = R.AZ.ACCOUNT<AZ.CUSTOMER>
    R.CUSTOMER = ''
* READ R.CUSTOMER FROM F.CUSTOMER,CUST.ID ELSE CUS.ERR = "Record not Read" ;*Tus Start
    CALL F.READ(FN.CUSTOMER,CUST.ID,R.CUSTOMER,F.CUSTOMER,R.CUSTOMER.ERR)
    IF R.CUSTOMER.ERR THEN
        CUS.ERR = "Record not Read"
    END ;*Tus End
    IF R.CUSTOMER THEN
        CUSTOMER.CODE = R.CUSTOMER
* CALL APAP.DRREG.DR.REGREP.GET.CUSTOMER.CODE(CUSTOMER.CODE, CUS.LOC.POS) ;*R22 MANUAL CODE CONVERSION
        CALL APAP.DRREG.drRegrepGetCustomerCode(CUSTOMER.CODE, CUS.LOC.POS) ;*R22 MANUAL CODE CONVERSION
    END

RETURN


*----------------------------------------------------------------------------
GET.ACCOUNTING.HEAD:
*----------------------------------------------------------------------------
*
*** FIELD(S) 37 & 38
*
    REP.HEAD = '' ; R.F.REDO.AZACC.DESC = ''
* READ R.F.REDO.AZACC.DESC FROM F.REDO.AZACC.DESC,ACCT.ENT.ID THEN ;*Tus Start
    CALL F.READ(FN.REDO.AZACC.DESC,ACCT.ENT.ID,R.F.REDO.AZACC.DESC,F.REDO.AZACC.DESC,R.F.REDO.AZACC.DESC.ERR)
    IF R.F.REDO.AZACC.DESC THEN ;* Tus End

        V.ACCOUNTING.HEAD = R.F.REDO.AZACC.DESC
        CALL APAP.DRREG.drRegGetAccountingHead(V.ACCOUNTING.HEAD,L.ASSET.TYPE) ;*R22 MANUAL CODE CONVERSION

    END ELSE
        V.ACCOUNTING.HEAD = ''
    END


RETURN

*----------------------------------------------------------------------------
GET.PI.INT.FLAG:
*----------------------------------------------------------------------------
*
*** FIELD 18
*
    Y.AZ.TYPE.OF.SCH = '' ; Y.AZ.TYPE.OF.SCH = R.AZ.ACCOUNT<AZ.TYPE.OF.SCHDLE>
    Y.AZ.FREQUENCY = '' ; Y.AZ.FREQUENCY = R.AZ.ACCOUNT<AZ.FREQUENCY>

    LOCATE 'I' IN Y.AZ.TYPE.OF.SCH<1,1> SETTING SCH.POS THEN
        Y.AZ.INT.FREQ = Y.AZ.FREQUENCY<1,SCH.POS>
    END

    BEGIN CASE
        CASE R.AZ.ACCOUNT<AZ.SCHEDULES>[1,1] EQ 'Y'
            Y.PI.INT = 'V'

        CASE Y.AZ.INT.FREQ[9,3] EQ 'M12'
            Y.PI.INT = 'A'

        CASE Y.AZ.INT.FREQ[9,3] EQ 'M06'
            Y.PI.INT = 'S'

        CASE Y.AZ.INT.FREQ[9,3] EQ 'M04'
            Y.PI.INT = 'C'

        CASE Y.AZ.INT.FREQ[9,3] EQ 'M03'
            Y.PI.INT = 'T'

        CASE Y.AZ.INT.FREQ[9,3] EQ 'M02'
            Y.PI.INT = 'B'

        CASE Y.AZ.INT.FREQ[9,3] EQ 'M01'
            Y.PI.INT = 'M'

        CASE Y.AZ.INT.FREQ[9,3] EQ '' AND (Y.AZ.INT.FREQ EQ R.AZ.ACCOUNT<AZ.MATURITY.DATE>)
            Y.PI.INT = 'V'

        CASE 1 ;****Incase none of the above conditions are true
            Y.PI.INT = 'V'

    END CASE


RETURN


*----------------------------------------------------------------------------
GET.AZ.INT.AMOUNT:
*----------------------------------------------------------------------------
*
*** CHECK WITH REJETH **** FIELD 17

    BALANCE.TYPE = '50000'
    SUB.TYPE = ''
    BAL.DATE = TODAY
    ECB.BALANCE = ''
    ECB.BAL.LCY = ''

    CALL AC.GET.ECB.BALANCE(AZ.ID, BALANCE.TYPE, SUB.TYPE, BAL.DATE, ECB.BALANCE, ECB.BAL.LCY)

RETURN


*----------------------------------------------------------------------------
GET.INT.REINVEST.AMT:
*----------------------------------------------------------------------------
*
**** AS PER REJETH MAPPING DOC

    IF R.ACCOUNT<AC.LOCAL.REF><1,AC.REINVESTED.POS> EQ 'YES' THEN
        Y.REINVEST.AC.ID = '' ; Y.REINVEST.AC.ID = R.ACCOUNT<AC.INTEREST.LIQU.ACCT>
* READ R.REINVEST.AC FROM F.ACCOUNT,Y.REINVEST.AC.ID THEN ;*Tus Start
        CALL F.READ(FN.ACCOUNT,Y.REINVEST.AC.ID,R.REINVEST.AC,F.ACCOUNT,R.REINVEST.AC.ERR)
        IF R.REINVEST.AC THEN
            R.ECB=''
            ECB.ERR=''
            CALL EB.READ.HVT('EB.CONTRACT.BALANCES',Y.REINVEST.AC.ID,R.ECB,ECB.ERR);*Tus end
            Y.REINVEST.AMOUNT = ''
            Y.REINVEST.AMOUNT = R.ECB<ECB.WORKING.BALANCE>;*Tus Start
*Y.REINVEST.AMOUNT = R.REINVEST.AC<AC.WORKING.BALANCE>;*Tus end
        END
    END ELSE
        Y.REINVEST.AMOUNT = '0.00'
    END


RETURN

*----------------------------------------------------------------------------
INIT.PARA:
*----------------------------------------------------------------------------
*
    PROCESS.GO.AHEAD = 1
    CUS.LOC.POS = ''
    REC.COUNT = 0

    GOSUB OPEN.FILES
*GOSUB GET.LR.POSN

    PROC.DATE = TODAY
    EXTR.DATE = PROC.DATE[7,2] : PROC.DATE[5,2] : PROC.DATE[1,4]
    PROC.DATE = PROC.DATE[7,2] :'/': PROC.DATE[5,2] :'/': PROC.DATE[1,4]

    REGREP.SYS.ID = 'SYSTEM' ; R.REGREP.SYSTEM = '' ; ERR.REGREP.SYSTEM = ''

    CALL CACHE.READ(FN.DR.REGREP.PARAM, REGREP.SYS.ID, R.REGREP.SYSTEM, ERR.REGREP.SYSTEM)

    IF ERR.REGREP.SYSTEM EQ '' THEN

        REGREP.FILE.PATH = R.REGREP.SYSTEM<DR.REG.REPORT.PATH>
        REPORT.ID = 'INTCAPPLZMN-' : TODAY :'.txt'
        OPENSEQ REGREP.FILE.PATH,REPORT.ID TO F.REGREPORT ELSE PRINT 'ERROR ON OPEN'

    END ELSE
        PROCESS.GO.AHEAD = 0

    END

RETURN


*----------------------------------------------------------------------------
SEL.PARA:
*----------------------------------------------------------------------------
*
    SEL.CMD = '' ; REC.COUNT = 0
    SEL.CMD = 'SELECT ':FN.AZ.ACCOUNT

    CALL EB.READLIST(SEL.CMD, AZ.ID.LIST, '', REC.COUNT, AZ.SEL.ERR)


RETURN


*----------------------------------------------------------------------------
OPEN.FILES:
*----------------------------------------------------------------------------
*
    FN.DR.REGREP.PARAM = 'F.DR.REGREP.PARAM'
    F.DR.REGREP.PARAM = ''
    CALL OPF(FN.DR.REGREP.PARAM, F.DR.REGREP.PARAM)

    FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'
    F.AZ.ACCOUNT = ''
    CALL OPF(FN.AZ.ACCOUNT, F.AZ.ACCOUNT)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT, F.ACCOUNT)

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMRE = ''
    CALL OPF(FN.CUSTOMER, F.CUSTOMER)

    FN.REDO.AZACC.DESC = 'F.REDO.AZACC.DESC'
    F.REDO.AZACC.DESC = ''
    CALL OPF(FN.REDO.AZACC.DESC, F.REDO.AZACC.DESC)
*Tus Start
*----------------------------------------------------------------------------
*GET.LR.POSN:
*----------------------------------------------------------------------------
*
*APPL = 'AZ.ACCOUNT' ; FIELDNAME = 'L.AZ.SHA1.CODE' ; RNC.POS = ''
*CALL GET.LOC.REF(APPL, FIELDNAME, RNC.POS)
*L.AZ.SHA1.CODE.POS = RNC.POS

*APPL = 'AZ.ACCOUNT' ; FIELDNAME = 'L.AC.STATUS1' ; STATUS1.POS = 'V'
*CALL GET.LOC.REF(APPL, FIELDNAME, STATUS1.POS)

*APPL = 'AZ.ACCOUNT' ; FIELDNAME = 'L.AC.STATUS2' ; STATUS2.POS = 'V'
*CALL GET.LOC.REF(APPL, FIELDNAME, STATUS2.POS)

*APPL = 'ACCOUNT' ; FIELDNAME = 'L.AC.REINVESTED' ; AC.REINVESTED.POS = ''
*CALL GET.LOC.REF(APPL, FIELDNAME, AC.REINVESTED.POS)

*CUS.LOC.POS = ''
*APPL = 'CUSTOMER' ; FIELDNAME = 'L.CU.CIDENT' ; CIDENT.POS = ''
*CALL GET.LOC.REF (APPL, FIELDNAME, CIDENT.POS)
*CUS.LOC.POS<1> = CIDENT.POS

*APPL = 'CUSTOMER' ; FIELDNAME = 'L.CU.RNC' ; RNC.POS = ''
*CALL GET.LOC.REF (APPL, FIELDNAME, RNC.POS)
*CUS.LOC.POS<2> = RNC.POS

*APPL = 'CUSTOMER' ; FIELDNAME = 'L.CU.NOUNICO' ; NOUNICO.POS = ''
*CALL GET.LOC.REF (APPL, FIELDNAME, NOUNICO.POS)
*CUS.LOC.POS<3> = NOUNICO.POS

*APPL = 'CUSTOMER' ; FIELDNAME = 'L.CU.ACTANAC' ; ACTANAC.POS = ''
*CALL GET.LOC.REF (APPL, FIELDNAME, ACTANAC.POS)
*CUS.LOC.POS<4> = ACTANAC.POS

*APPL = 'CUSTOMER' ; FIELDNAME = 'L.CU.TIPO.CL' ; TIPO.CL.POS = ''
*CALL GET.LOC.REF (APPL, FIELDNAME, TIPO.CL.POS)
*Tus End

*----------------------------------------------------------------------------
GET.OTHER.PARAMS:
*----------------------------------------------------------------------------
*
    ID.TABLE.PRODUCTOS = 'TABLE.PRODUCTOS' ; R.TABLE.PRODUCTOS = '' ; E.TABLE.PRODUCTOS = ''
    CALL CACHE.READ(FN.DR.REGREP.PARAM, ID.TABLE.PRODUCTOS, R.TABLE.PRODUCTOS, E.TABLE.PRODUCTOS)

    ID.TABLE.E = 'TABLE.E' ; R.TABLE.E = '' ; E.TABLE.E = ''
    CALL CACHE.READ(FN.DR.REGREP.PARAM, ID.TABLE.E, R.TABLE.E, E.TABLE.E)

    ID.TABLE.J = 'TABLE.J' ; R.TABLE.J = '' ; E.TABLE.J = ''
    CALL CACHE.READ(FN.DR.REGREP.PARAM, ID.TABLE.J, R.TABLE.J, E.TABLE.J)

    ID.TABLE.O = 'TABLE.O' ; R.TABLE.O = '' ; E.TABLE.O = ''
    CALL CACHE.READ(FN.DR.REGREP.PARAM, ID.TABLE.O, R.TABLE.O, E.TABLE.O)

    ID.TABLE.REL.CODES = 'TABLE.RELATION.CODES' ; R.TABLE.REL.CODES = '' ; E.TABLE.REL.CODES = ''
    CALL CACHE.READ(FN.DR.REGREP.PARAM, ID.TABLE.REL.CODES, R.TABLE.REL.CODES, E.TABLE.REL.CODES)

    ID.TABLE.LOCATION = 'TABLE.LOCATION' ; R.TABLE.LOCATION = '' ; E.TABLE.LOCATION = ''
    CALL CACHE.READ(FN.DR.REGREP.PARAM, ID.TABLE.LOCATION, R.TABLE.LOCATION, E.TABLE.LOCATION)


RETURN

*----------------------------------------------------------------------------
PRINT.HEADER:
*----------------------------------------------------------------------------
*
    WRITESEQ '4-01-00013-1' TO F.REGREPORT ELSE PRINT 'ERROR ON HEADER'
    WRITESEQ 'INTCAPPLZMN' TO F.REGREPORT ELSE PRINT 'ERROR ON HEADER'
    WRITESEQ PROC.DATE:',':PROC.DATE TO F.REGREPORT ELSE PRINT 'ERROR ON HEADER'
    WRITESEQ FMT(REC.COUNT,"12'0'R") TO F.REGREPORT ELSE PRINT 'ERROR ON HEADER'
    WRITESEQ FMT('0',"5'0'R") TO F.REGREPORT ELSE PRINT 'ERROR ON HEADER'
    WRITESEQ FMT('0',"12'0'R") TO F.REGREPORT ELSE PRINT 'ERROR ON HEADER'

RETURN



* Tus start
*************************
MULTI.GET.LOC.REF.DEFINE:
*************************
    Y.LREF.APP =''
    Y.LREF.FIELD= ''
    Y.LREF.POS = ''
    L.AZ.SHA1.CODE.POS = ''
    STATUS1.POS = ''
    STATUS2.POS = ''
    AC.REINVESTED.POS = ''
    CUS.LOC.POS<1> = ''
    CUS.LOC.POS<2> = ''
    CUS.LOC.POS<3> = ''
    CUS.LOC.POS<4> = ''
    TIPO.CL.POS = ''
    Y.LREF.APP = "AZ.ACCOUNT":@FM:"ACCOUNT":@FM:"CUSTOMER"
    Y.LREF.FIELD = "L.AZ.SHA1.CODE":@VM:"L.AC.STATUS1":@VM:"L.AC.STATUS2":@FM:"L.AC.REINVESTED":@FM:"L.CU.CIDENT":@VM:"L.CU.RNC":@VM:"L.CU.NOUNICO":@VM:"L.CU.ACTANAC":@VM:"L.CU.TIPO.CL"
    CALL MULTI.GET.LOC.REF(Y.LREF.APP,Y.LREF.FIELD,Y.LREF.POS)
    L.AZ.SHA1.CODE.POS = Y.LREF.POS<1,1>
    STATUS1.POS = Y.LREF.POS<1,2>
    STATUS2.POS = Y.LREF.POS<1,3>
    AC.REINVESTED.POS = Y.LREF.POS<2,1>
    CUS.LOC.POS<1> = Y.LREF.POS<3,1>
    CUS.LOC.POS<2> = Y.LREF.POS<3,2>
    CUS.LOC.POS<3> = Y.LREF.POS<3,3>
    CUS.LOC.POS<4> = Y.LREF.POS<3,4>
    TIPO.CL.POS = Y.LREF.POS<3,5>
RETURN
* Tus end
END
