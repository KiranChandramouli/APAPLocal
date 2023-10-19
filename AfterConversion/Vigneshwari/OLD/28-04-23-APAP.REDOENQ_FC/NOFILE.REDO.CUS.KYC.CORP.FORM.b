* @ValidationCode : Mjo0MjgzNDg0NjY6Q3AxMjUyOjE2ODI1MDc5ODU4MzI6dmlnbmVzaHdhcmk6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 26 Apr 2023 16:49:45
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
$PACKAGE APAP.REDOENQ
SUBROUTINE NOFILE.REDO.CUS.KYC.CORP.FORM(CUS.DET.ARR)
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This is Nofile routine to fetch the values for KYC form from CUSTOMER file
* This development is for ODR Reference ODR-2010-04-0425
* Input/Output:
*--------------
* IN  : CUST.ID
* OUT : CUSD.ID
* Dependencies:
*---------------
* CALLS     : -NA-
* CALLED BY : -NA-
* Revision History:
*------------------------------------------------------------------------------------------
* Date                 who              Reference                                    Description
* 13-MAY-2010          B Renugadevi     ODR-2010-04-0425                             Initial Creation
* 13-MAY-2011          Sudharsanan S    PACS00023993                                 Modify as per Issue
* 16 JUN 2011          MANJU.G          PACS00072193                                 Select stmt modified
* 18 JUL 2011          SUDHARSANAN S    PACS00084100,PACS00072193 & PACS00086261     Modify the mapping of fields
* 15 AUG 2011          SUDHARSANAN S    PACS00102852                                 Check the multi value for segment field
*  DATE             WHO                   REFERENCE
* 06-APRIL-2023      Conversion Tool       R22 Auto Conversion  - VM to @VM , FM to @FM ,SM to @SM , F.READ to CACHE.READ and ++ to +=1
* 06-APRIL-2023      Harsha                R22 Manual Conversion - Call routine modified
*------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER.ACCOUNT
    $INSERT I_F.AZ.CUSTOMER
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.AZ.PRODUCT.PARAMETER
    $INSERT I_F.COUNTRY
    $INSERT I_F.USER
    $INSERT I_F.SECTOR
    $INSERT I_F.INDUSTRY
    $INSERT I_F.DEPT.ACCT.OFFICER
    $INSERT I_F.REDO.RISK.GROUP
    $INSERT I_F.REDO.SECTOR.DOMI
    $INSERT I_F.REDO.URB.ENS.RES.DOMI
    $INSERT I_F.CR.PROFILE.TYPE
    $INSERT I_F.CUST.DOCUMENT
    $INSERT I_F.CATEGORY
    $INSERT I_F.APAP.INDUSTRY
    $USING APAP.TAM
    $USING APAP.REDORETAIL
    GOSUB INIT
    GOSUB PROCESS
RETURN
******
INIT:
******
    CUSTOMER.NO              = '' ; VAR.RE.INV.CATEG = ''
    CUS.CORPORATE.NAME       = '' ; CUS.ID.NR                = '' ; CUS.PARTICIPATION        = '' ; SHA.CORPORATE.NAME       = ''
    SHA.ID.NR                = '' ; SHA.PARTICIPATION        = '' ; FIN.INST.ONE             = '' ; FIN.INST.TWO             = ''
    FIN.INST.THREE           = '' ; FIN.INST.FOUR            = ''
*
    FN.CUSTOMER              = 'F.CUSTOMER'             ; F.CUSTOMER               = ''
    FN.ACCOUNT               = 'F.ACCOUNT'              ; F.ACCOUNT                = ''
    FN.CUSTOMER.ACCOUNT      = 'F.CUSTOMER.ACCOUNT'     ; F.CUSTOMER.ACCOUNT       = ''
    FN.SECTOR                = 'F.SECTOR'               ; F.SECTOR                 = ''
*   FN.INDUSTRY              = 'F.INDUSTRY'             ; F.INDUSTRY               = ''
    FN.APAP.INDUSTRY = 'F.APAP.INDUSTRY'
    F.APAP.INDUSTRY = ''
    CALL OPF(FN.APAP.INDUSTRY,F.APAP.INDUSTRY)
    FN.REDO.RISK.GROUP       = 'F.REDO.RISK.GROUP'      ; F.REDO.RISK.GROUP        = ''
    FN.REDO.SECTOR.DOMI      = 'F.REDO.SECTOR.DOMI'     ; F.REDO.SECTOR.DOMI       = ''
    FN.REDO.URB.ENS.RES.DOMI = 'F.REDO.URB.ENS.RES.DOMI'; F.REDO.URB.ENS.RES.DOMI  = ''
    FN.DEPT.ACCT.OFFICER     = 'F.DEPT.ACCT.OFFICER'    ; F.DEPT.ACCT.OFFICER      = ''
    FN.AZ.CUSTOMER           = 'F.AZ.CUSTOMER'          ; F.AZ.CUSTOMER            = ''
    FN.AZ.ACCOUNT            = 'F.AZ.ACCOUNT'           ; F.AZ.ACCOUNT             = ''
    FN.APP                   = 'F.AZ.PRODUCT.PARAMETER' ; F.APP                    = ''
    FN.CR.PROFILE.TYPE       = 'F.CR.PROFILE.TYPE'      ; F.CR.PROFILE.TYPE        = ''
    FN.COUNTRY               = 'F.COUNTRY'              ; F.COUNTRY                = ''
    FN.CUST.DOC              = 'F.CUST.DOCUMENT'        ; F.CUST.DOC = ''
    FN.CATEGORY  = 'F.CATEGORY' ; F.CATEGORY = ''
*
    CALL OPF(FN.CUSTOMER, F.CUSTOMER)
    CALL OPF(FN.ACCOUNT, F.ACCOUNT)
    CALL OPF(FN.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT)
    CALL OPF(FN.COUNTRY,F.COUNTRY)
    CALL OPF(FN.SECTOR,F.SECTOR)
*   CALL OPF(FN.INDUSTRY,F.INDUSTRY)
    CALL OPF(FN.REDO.RISK.GROUP,F.REDO.RISK.GROUP)
    CALL OPF(FN.REDO.SECTOR.DOMI,F.REDO.SECTOR.DOMI)
    CALL OPF(FN.REDO.URB.ENS.RES.DOMI,F.REDO.URB.ENS.RES.DOMI)
    CALL OPF(FN.DEPT.ACCT.OFFICER,F.DEPT.ACCT.OFFICER)
    CALL OPF(FN.AZ.CUSTOMER,F.AZ.CUSTOMER)
    CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)
    CALL OPF(FN.APP,F.APP)
    CALL OPF(FN.CUST.DOC,F.CUST.DOC)
    CALL OPF(FN.CATEGORY,F.CATEGORY)
*
    LREF.APPL                = 'CUSTOMER':@FM:'ACCOUNT':@FM:'AZ.ACCOUNT':@FM:'AZ.PRODUCT.PARAMETER':@FM:'CUST.DOCUMENT'
    LREF.FIELDS              = 'L.CU.ALT.CU.COD':@VM:'L.CU.RNC':@VM:'L.CU.GRP.RIESGO':@VM:'L.CU.RES.SECTOR':@VM:'L.CU.URB.ENS.RE':@VM:'L.CU.TEL.TYPE':@VM:'L.CU.TEL.AREA':@VM:'L.CU.TEL.NO':@VM:'L.CU.TEL.EXT':@VM:'L.CU.TEL.P.CONT':@VM:'L.CU.RNC':@VM:'L.APAP.INDUSTRY'
    LREF.FIELDS<-1>          = 'L.AC.SRCINITDEP':@VM:'L.AC.TOT.DEP':@VM:'L.AC.CASH.DEP':@VM:'L.AC.CHQ.DEP':@VM:'L.AC.TRANS.DEP':@VM:'L.AC.TOT.WITHDR':@VM:'L.AC.CASHWITHDR':@VM:'L.AC.CHQWITHDR':@VM:'L.AC.TRANS.WDR':@VM:'L.AC.QTY.DEPOS':@VM:'L.AC.QTY.WITHDR':@VM:'L.AC.PROP.USE':@VM:'L.AC.FUNDORIGIN'
    LREF.FIELDS<-1>          = 'L.AC.SRCINITDEP':@VM:'L.AC.PROP.USE':@VM:'L.AC.FUNDORIGIN'
    LREF.FIELDS<-1>          = 'L.AZ.RE.INV.CAT'
    LREF.FIELDS<-1>          = 'L.DM.ISSDATE'
    LREF.POS                 = ''
    CALL MULTI.GET.LOC.REF(LREF.APPL,LREF.FIELDS,LREF.POS)
    L.CU.ALT.CU.COD.POS      = LREF.POS<1,1>
    L.CU.RNC.POS             = LREF.POS<1,2>
    L.CU.GROUP.RIESGO.POS      = LREF.POS<1,3>
    L.CU.RES.SECTOR.POS      = LREF.POS<1,4>
    L.CU.URB.ENS.RE.POS      = LREF.POS<1,5>
    L.CU.TEL.TYPE.POS        = LREF.POS<1,6>
    L.CU.TEL.AREA.POS        = LREF.POS<1,7>
    L.CU.TEL.NO.POS          = LREF.POS<1,8>
    L.CU.TEL.EXT.POS         = LREF.POS<1,9>
    L.CU.TEL.P.CONT.POS      = LREF.POS<1,10>
    Y.L.APAP.INDUS.POS = LREF.POS<1,11>
    Y.POS.AC.SRCNI           = LREF.POS<2,1>
    TOT.DEP.POS              = LREF.POS<2,2>
    Y.POS.DEP.CASH           = LREF.POS<2,3>
    Y.POS.DEP.CHQ            = LREF.POS<2,4>
    Y.POS.DEP.TR             = LREF.POS<2,5>
    TOT.WITHD.POS            = LREF.POS<2,6>
    Y.POS.WITH.CASH          = LREF.POS<2,7>
    Y.POS.WITH.CHQ           = LREF.POS<2,8>
    Y.POS.WITH.TR            = LREF.POS<2,9>
    Y.POS.QTY.DEP            = LREF.POS<2,10>
    Y.POS.QTY.WITH           = LREF.POS<2,11>
    Y.POS.PROP.USE           = LREF.POS<2,12>
    Y.POS.FUND.ORIGIN        = LREF.POS<2,13>
    Y.POS.AZ.SRCINI          = LREF.POS<3,1>
    Y.POS.AZ.PROP            = LREF.POS<3,2>
    Y.POS.AZ.FUND            = LREF.POS<3,3>
    Y.POS.RE.INV.CAT         = LREF.POS<4,1>
    Y.POS.ISSDATE            = LREF.POS<5,1>
    VAR.USER.LANG = R.USER<EB.USE.LANGUAGE>
    GOSUB GET.VALUES
    GOSUB GET.REINV.CATEG
RETURN
**********************
GET.REINV.CATEG:
**********************
*This para is used to get the reinvestment category value for all records in the Application
    SEL.APP = "SSELECT ":FN.APP:" WITH L.AZ.RE.INV.CAT NE '' "
    CALL EB.READLIST(SEL.APP,SEL.APP.LIST,'',NOR.APP,APP.ERR)
    APP.CNT = 1
    LOOP
    WHILE APP.CNT LE NOR.APP
        APP.ID = SEL.APP.LIST<APP.CNT>
        CALL CACHE.READ(FN.APP,APP.ID,R.APP,AP.ER)
        RE.INV.CATEG = R.APP<AZ.APP.LOCAL.REF,Y.POS.RE.INV.CAT>
        IF RE.INV.CATEG THEN
            VAR.RE.INV.CATEG<-1> = R.APP<AZ.APP.LOCAL.REF,Y.POS.RE.INV.CAT>
        END
        APP.CNT += 1
    REPEAT
RETURN
*********
PROCESS:
*********
*PACS00072193 - S
    VALUE.BK = D.RANGE.AND.VALUE ;  OPERAND.BK = D.LOGICAL.OPERANDS ;  FIELDS.BK = D.FIELDS
    D.RANGE.AND.VALUE='' ; D.LOGICAL.OPERANDS=''; D.FIELDS=''
    CUS.APP.FLDS = '@ID':@FM:'L.CU.RNC'
    LOOP
        REMOVE APP.FLD FROM CUS.APP.FLDS SETTING CUS.FLD.POS
    WHILE APP.FLD:CUS.FLD.POS
        LOCATE APP.FLD IN FIELDS.BK<1> SETTING POS1 THEN
            D.RANGE.AND.VALUE<-1>=VALUE.BK<POS1>
            D.LOGICAL.OPERANDS<-1>=OPERAND.BK<POS1>
            D.FIELDS<-1>=FIELDS.BK<POS1>
        END
    REPEAT
    IF D.FIELDS NE '' THEN
        FILE.NAME = FN.CUSTOMER
*CALL APAP.REDOENQ.REDO.E.FORM.SEL.STMT(FILE.NAME, '', '', SEL.CUS.CMD)
        CALL APAP.REDOENQ.RedoEFormSelStmt(FILE.NAME, '', '', SEL.CUS.CMD) ;*R22 Manual Conversion - Added APAP.REDOFCFI
        SEL.CMD1 = SEL.CUS.CMD:" AND (L.CU.TIPO.CL EQ 'PERSONA JURIDICA')"
    END  ELSE
        SEL.CMD1 = "SELECT ":FN.CUSTOMER:" WITH (L.CU.TIPO.CL EQ 'PERSONA JURIDICA')"
    END
    CALL EB.READLIST(SEL.CMD1,SEL.LIST,'',NOR,SEL.ERR)
    Y.SEL.COUNT = DCOUNT(SEL.LIST,@FM)
    Y.SEL.CT.LOOP = 1
    LOOP
    WHILE Y.SEL.CT.LOOP LE Y.SEL.COUNT
        CUST.ID = SEL.LIST<Y.SEL.CT.LOOP>
        R.CUST                     = '' ; CUST.ERR      = ''
        CALL F.READ(FN.CUSTOMER,CUST.ID,R.CUST,F.CUSTOMER,CUST.ERR)
        Y.SEL.CT.LOOP + =1
        GOSUB PROCESS.EXTRACT
    REPEAT
*PACS00072193 - E
RETURN
***********************************************************************************
PROCESS.EXTRACT:
******************

    CALL APAP.REDOENQ.redoExecSecInfo(CUST.ID,OTH.OFFICER);* R22 Manual Conversion
    BRANCH                     = OTH.OFFICER
    CUSTOMER.CODE              = CUST.ID
    ALTERNATE.CUSTOMER.NO      = " "      ;*******This field is removed as discussion with client   R.CUST<EB.CUS.LOCAL.REF,L.CU.ALT.CU.COD.POS>
    Y.DATE                     = TODAY
    CALL APAP.TAM.redoShowCustDesc(CUST.ID,STATUS.DESC) ;*R22 Manual Conversion
    Y.STATUS                   = STATUS.DESC
    RNC                        = R.CUST<EB.CUS.LOCAL.REF,L.CU.RNC.POS>
    COMMER.REGI.NR             = R.CUST<EB.CUS.PREVIOUS.NAME,1>
    VAR.CUST.END.DATE          = CUST.ID:"*REGMERC"
    CALL F.READ(FN.CUST.DOC,VAR.CUST.END.DATE,R.CUST.DOC,F.CUST.DOC,CUS.DOC.ERR)
    COMM.REGI.NO.END.DATE      = R.CUST.DOC<CUS.DOC.END.DATE> ;*******************************New Field
    CORPORATE.NAME             = R.CUST<EB.CUS.NAME.1>:R.CUST<EB.CUS.NAME.2>
    COMMERCIAL.NAME            = R.CUST<EB.CUS.TEXT,1>
    RELATION.STARTING.DATE     = R.CUST<EB.CUS.CUSTOMER.SINCE>
    VAR.SECTOR                 = R.CUST<EB.CUS.SECTOR>
    CALL CACHE.READ(FN.SECTOR, VAR.SECTOR, R.SECTOR, SEC.ERR)     ;*R22 Auto Conversion  - F.READ to CACHE.READ
    SECTOR                     = R.SECTOR<EB.SEC.DESCRIPTION,VAR.USER.LANG>
    IF NOT(SECTOR) THEN
        SECTOR                 = R.SECTOR<EB.SEC.DESCRIPTION,1>
    END
*   VAR.MAIN.ECONOMIC.ACT      = R.CUST<EB.CUS.INDUSTRY>
    VAR.MAIN.ECONOMIC.ACT = R.CUST<EB.CUS.LOCAL.REF,Y.L.APAP.INDUS.POS>
*   CALL F.READ(FN.INDUSTRY,VAR.MAIN.ECONOMIC.ACT,R.INDUSTRY,F.INDUSTRY,IND.ERR)
    CALL F.READ(FN.APAP.INDUSTRY,VAR.MAIN.ECONOMIC.ACT,R.INDUSTRY,F.APAP.INDUSTRY,IND.ERR)
*   MAIN.ECONOMIC.ACTIVITY   = R.INDUSTRY<EB.IND.DESCRIPTION,VAR.USER.LANG>
    MAIN.ECONOMIC.ACTIVITY = R.INDUSTRY<REDO.DESCRIPTION,VAR.USER.LANG>
    IF NOT(MAIN.ECONOMIC.ACTIVITY) THEN
*       MAIN.ECONOMIC.ACTIVITY   = R.INDUSTRY<EB.IND.DESCRIPTION,1>
        MAIN.ECONOMIC.ACTIVITY = R.INDUSTRY<REDO.DESCRIPTION,1>
    END
    VAR.GROUP.RISK           = R.CUST<EB.CUS.LOCAL.REF,L.CU.GROUP.RIESGO.POS>
    VAR.GROUP.JAVA.RISK = ''

    CHANGE @SM TO @FM IN VAR.GROUP.RISK
    RISK.GROUP.CNT = DCOUNT(VAR.GROUP.RISK,@FM) ; CNT.RISK = 1
    LOOP
    WHILE CNT.RISK LE RISK.GROUP.CNT
        VAR.GROUP.RISK.ID = VAR.GROUP.RISK<CNT.RISK>
        CALL F.READ(FN.REDO.RISK.GROUP,VAR.GROUP.RISK.ID,R.REDO.RISK.GROUP,F.REDO.RISK.GROUP,RISK.ERR)
        GROUP.RISK<1,-1>               = R.REDO.RISK.GROUP<RG.RISK.GRP.DESC,1>
        IF VAR.GROUP.JAVA.RISK EQ '' THEN
            VAR.GROUP.JAVA.RISK = R.REDO.RISK.GROUP<RG.RISK.GRP.DESC,1>
        END ELSE
            VAR.GROUP.JAVA.RISK = VAR.GROUP.JAVA.RISK : '##' : R.REDO.RISK.GROUP<RG.RISK.GRP.DESC,1>
        END

        CNT.RISK += 1
    REPEAT
    VAR.EXEC.RESPONSIBLE     = R.CUST<EB.CUS.ACCOUNT.OFFICER,1>
    CALL CACHE.READ(FN.DEPT.ACCT.OFFICER, VAR.EXEC.RESPONSIBLE, R.DEPT.ACCT.OFFICER, DEPT.ERR)    ;*R22 Auto Conversion  - F.READ to CACHE.READ
    EXECUTIVE.RESPONSIBLE  = R.DEPT.ACCT.OFFICER<EB.DAO.NAME>
    SEC.EXECUTIVE              = ''       ;*******This field is removed as discussion with client
    VAR.ADDRESS.TYPE         = R.CUST<EB.CUS.RESIDENCE.TYPE>
    LOCATE VAR.ADDRESS.TYPE IN Y.LOOKUP.LIST10 SETTING POS10 THEN
        ADDRESS.TYPE = Y.LOOKUP.DESC10<POS10,VAR.USER.LANG>
        IF NOT(ADDRESS.TYPE) THEN
            ADDRESS.TYPE = Y.LOOKUP.DESC10<POS10,1>
        END
    END
    VAR.COUNTRY              = R.CUST<EB.CUS.RESIDENCE>
    CALL CACHE.READ(FN.COUNTRY, VAR.COUNTRY, R.COUNTRY, COUNT.ERR)   ;*R22 Auto Conversion  - F.READ to CACHE.READ
    IF R.COUNTRY THEN
        COUNTRY              = R.COUNTRY<EB.COU.COUNTRY.NAME>
    END
    PROVINCE                   = R.CUST<EB.CUS.TOWN.COUNTRY>
    CITY                       = R.CUST<EB.CUS.COUNTRY>
    VAR.SECTOR.2             = R.CUST<EB.CUS.LOCAL.REF,L.CU.RES.SECTOR.POS>
    CALL F.READ(FN.REDO.SECTOR.DOMI,VAR.SECTOR.2,R.SECTOR.DOMI,F.REDO.SECTOR.DOMI,DOMI.ERR)
    SECTOR.2                 = R.SECTOR.DOMI<XX.YY.DESCRIPTION,VAR.USER.LANG>
    IF NOT(SECTOR.2) THEN
        SECTOR.2             = R.SECTOR.DOMI<XX.YY.DESCRIPTION,1>
    END
    VAR.URB.ENS.RE           = R.CUST<EB.CUS.LOCAL.REF,L.CU.URB.ENS.RE.POS>
    CALL F.READ(FN.REDO.URB.ENS.RES.DOMI,VAR.URB.ENS.RE,R.URB.ENS.RE,F.REDO.URB.ENS.RES.DOMI,URB.ERR)
    URB.ENS.RES              = R.URB.ENS.RE<XX.YY.DESCRIPTION,VAR.USER.LANG>
    IF NOT(URB.ENS.RES) THEN
        URB.ENS.RES          = R.URB.ENS.RE<XX.YY.DESCRIPTION,1>
    END
    STREET                     = R.CUST<EB.CUS.STREET>
    NUMBER.SUITABLE            = R.CUST<EB.CUS.ADDRESS>
    ZIP.CODE                   = R.CUST<EB.CUS.POST.CODE>
    PO.BOX                     = R.CUST<EB.CUS.OFF.PHONE>
    CALL APAP.TAM.redoRelcusTelType(CUST.ID,VAR.TEL.TYPE,VAR.TEL.AREA,VAR.TEL.NUMBER,VAR.TEL.EXT,VAR.TEL.CONTACT);*R22 Manual Conversion - Call routine modified
    TYPE                       = VAR.TEL.TYPE
    AREA                       = VAR.TEL.AREA
    NUMBER                     = VAR.TEL.NUMBER
    EXT                        = VAR.TEL.EXT
    CONTACT                    = VAR.TEL.CONTACT

    JAVA.TIPO=TYPE
    JAVA.AREA=AREA
    JAVA.NUMBER=NUMBER
    JAVA.EXTENSION=EXT
    JAVA.CONTACT=CONTACT
    CHANGE @VM TO '##' IN JAVA.TIPO
    CHANGE @VM TO '##' IN JAVA.AREA
    CHANGE @VM TO '##' IN JAVA.NUMBER
    CHANGE @VM TO '##' IN JAVA.EXTENSION
    CHANGE @VM TO '##' IN JAVA.CONTACT

    CALL APAP.REDORETAIL.redoDsBasicInfo(CUST.ID,NAME.CORP,ID.CORP,ROLE.1);*R22 Manual Conversion - Call routine modified
    CUS.CORPORATE.NAME         = NAME.CORP
    CUS.ID.NR                  = ID.CORP
    CUS.PARTICIPATION          = ROLE.1

    JAVA.CCN=CUS.CORPORATE.NAME
    JAVA.CID=CUS.ID.NR
    JAVA.PART=CUS.PARTICIPATION

    CHANGE @VM TO '##' IN JAVA.CCN
    CHANGE @VM TO '##' IN JAVA.CID
    CHANGE @VM TO '##' IN JAVA.PART

    VAR.CUST.ISS.DATE          = CUST.ID:"*ACTAASAM"
    CALL F.READ(FN.CUST.DOC,VAR.CUST.ISS.DATE,R.CUST.DOC,F.CUST.DOC,CUS.DOC.ERR)
    DATE.CONSTITUTE.ASS      = R.CUST.DOC<CUS.DOC.LOCAL.REF,Y.POS.ISSDATE>        ;********* new field
    CALL APAP.REDORETAIL.redoDsShaInfo(CUST.ID,SHA.NAME.CORP,SHA.ID.CORP,SHA.ROLE.1);*R22 Manual Conversion
    SHA.CORPORATE.NAME         = SHA.NAME.CORP
    SHA.ID.NR                  = SHA.ID.CORP
    SHA.PARTICIPATION          = SHA.ROLE.1

    JAVA.SCN=SHA.CORPORATE.NAME
    JAVA.SID=SHA.ID.NR
    JAVA.SPART=SHA.PARTICIPATION

    CHANGE @VM TO '##' IN JAVA.SCN
    CHANGE @VM TO '##' IN JAVA.SID
    CHANGE @VM TO '##' IN JAVA.SPART

    CALL APAP.REDORETAIL.redoCusOthFininsOne(CUST.ID,OTH.FIN);*R22 Manual Conversion
    FIN.INST.ONE               = OTH.FIN
    CALL APAP.REDORETAIL.redoCusOthFininsTwo(CUST.ID,OTH.FIN2);*R22 Manual Conversion
    FIN.INST.TWO               = OTH.FIN2
    CALL APAP.REDORETAIL.redoCusOthFininsThree(CUST.ID,OTH.FIN3) ;*R22 Manual Conversion
    FIN.INST.THREE             = OTH.FIN3
    CALL APAP.REDORETAIL.redoCusOthFininsFour(CUST.ID,OTH.FIN4) ;*R22 Manual Conversion
    FIN.INST.FOUR              = OTH.FIN4
    GOSUB GET.SEGMENTO
    GOSUB GET.CUS.AC.DET
    GOSUB FORM.CUST.DET.ARRAY
RETURN
*----------------------------------------------------------------------------------------------------------
GET.SEGMENTO:
*----------------------------------------------------------------------------------------------------------
*PACS00102852 - S
    VAR.SEGMENT              = R.CUST<EB.CUS.CR.PROFILE.TYPE>
    CHANGE @VM TO @FM IN VAR.SEGMENT
    SEG.CNT = DCOUNT(VAR.SEGMENT,@FM) ; CNT.SEGMENT = 1
    LOOP
    WHILE CNT.SEGMENT LE SEG.CNT
        VAR.SEGMENT.ID = VAR.SEGMENT<CNT.SEGMENT>
        CALL F.READ(FN.CR.PROFILE.TYPE,VAR.SEGMENT.ID,R.CR.PROFILE.TYPE,F.CR.PROFILE.TYPE,CR.ERR)
        Y.SEGMENT  = ''
        Y.SEGMENT                 = R.CR.PROFILE.TYPE<CR.PFL.TYP.DESC,VAR.USER.LANG>
        IF NOT(Y.SEGMENT) THEN
            SEGMENTO<1,-1>              = R.CR.PROFILE.TYPE<CR.PFL.TYP.DESC,1>
        END ELSE
            SEGMENTO<1,-1>              = Y.SEGMENT
        END
        CNT.SEGMENT += 1
    REPEAT
*PACS00102852 - E
RETURN
*------------------------------------------------------------------------------------------------------
GET.CUS.AC.DET:
*------------------------------------------------------------------------------------------------------
    CALL F.READ(FN.CUSTOMER.ACCOUNT,CUST.ID,R.CUS.ACC,F.CUSTOMER.ACCOUNT,CUS.AC.ER)
    CALL F.READ(FN.AZ.CUSTOMER,CUST.ID,R.AZ.CUS.ACC,F.AZ.CUSTOMER,AZ.CUS.ACC.ER)
    GOSUB GET.ACCOUNT.DETAILS
    GOSUB GET.AZACC.DETAILS
RETURN
*---------------------------------------------------------------------------------------------------------
FORM.CUST.DET.ARRAY:
*-----------------------------------------------------------------------------------------------------------

    JAVA.VAR.ACCOUNT=VAR.ACCOUNT
    JAVA.PRODUCT.CODE=PRODUCT.CODE
    JAVA.DEPOSIT.SOURCE=DEPOSIT.SOURCE
    JAVA.TOT.DEP=TOT.DEP
    JAVA.DEP.CASH=DEP.CASH
    JAVA.DEP.CHQ=DEP.CHQ
    JAVA.DEP.TRANS=DEP.TRANS
    JAVA.TOT.WITHD=TOT.WITHD
    JAVA.WITH.CASH=WITH.CASH
    JAVA.WITH.CHQ=WITH.CHQ
    JAVA.WITH.TRANS=WITH.TRANS
    JAVA.DEP.QTY=DEP.QTY
    JAVA.WITH.QTY=WITH.QTY
    JAVA.Y.PROP.USE=Y.PROP.USE
    JAVA.FUND.ORIGIN=FUND.ORIGIN
    JAVA.SEGMENTO=SEGMENTO



    CHANGE @VM TO '##' IN JAVA.VAR.ACCOUNT
    CHANGE @VM TO '##' IN JAVA.PRODUCT.CODE
    CHANGE @VM TO '##' IN JAVA.DEPOSIT.SOURCE
    CHANGE @SM TO '#@#' IN JAVA.DEPOSIT.SOURCE
    CHANGE @VM TO '##' IN JAVA.TOT.DEP
    CHANGE @VM TO '##' IN JAVA.DEP.CASH
    CHANGE @VM TO '##' IN JAVA.DEP.CHQ
    CHANGE @VM TO '##' IN JAVA.DEP.TRANS
    CHANGE @VM TO '##' IN JAVA.TOT.WITHD
    CHANGE @VM TO '##' IN JAVA.WITH.CASH
    CHANGE @VM TO '##' IN JAVA.WITH.CHQ
    CHANGE @VM TO '##' IN JAVA.WITH.TRANS
    CHANGE @VM TO '##' IN JAVA.DEP.QTY
    CHANGE @VM TO '##' IN JAVA.WITH.QTY
    CHANGE @VM TO '##' IN JAVA.Y.PROP.USE
    CHANGE @VM TO '##' IN JAVA.FUND.ORIGIN
    CHANGE @SM TO '#@#' IN JAVA.FUND.ORIGIN
    CHANGE @VM TO '##' IN JAVA.SEGMENTO

    JAVA.BUNCH.SET="^^SFD1=":JAVA.VAR.ACCOUNT:"^^SFD2=":JAVA.PRODUCT.CODE:"^^SFD3=":JAVA.DEPOSIT.SOURCE:"^^SFD4=":JAVA.TOT.DEP:"^^SFD5=":JAVA.DEP.CASH:"^^SFD6=":JAVA.DEP.CHQ:"^^SFD7=":JAVA.DEP.TRANS:"^^SFD8=":JAVA.TOT.WITHD:"^^SFD9=":JAVA.WITH.CASH:"^^SFD10=":JAVA.WITH.CHQ:"^^SFD11=":JAVA.WITH.TRANS:"^^SFD12=":JAVA.DEP.QTY:"^^SFD13=":JAVA.WITH.QTY:"^^SFD14=":JAVA.Y.PROP.USE:"^^SFD15=":JAVA.FUND.ORIGIN
    JAVA.BUNCH.SET:="^^SFD16=":JAVA.TIPO:"^^SFD17=":JAVA.AREA:"^^SFD18=":JAVA.NUMBER:"^^SFD19=":JAVA.EXTENSION:"^^SFD20=":JAVA.CCN:"^^SFD21=":JAVA.CID:"^^SFD22=":JAVA.PART:"^^SFD23=":JAVA.SCN:"^^SFD24=":JAVA.SID:"^^SFD25=":JAVA.SPART:"^^SFD26=":VAR.GROUP.JAVA.RISK:"^^SFD27=":JAVA.CONTACT:"^^SFD28=":JAVA.SEGMENTO
*************            1                     2                  3               4                 5                    6                 7
    CUS.DET.ARR<-1> = BRANCH:"VAR.SEP":CUSTOMER.CODE:"VAR.SEP":Y.DATE:"VAR.SEP":Y.STATUS:"VAR.SEP":RNC:"VAR.SEP":COMMER.REGI.NR:"VAR.SEP":COMM.REGI.NO.END.DATE
*************                    8                           9                         10                          11                    12                           13
    CUS.DET.ARR := "VAR.SEP":CORPORATE.NAME:"VAR.SEP":COMMERCIAL.NAME:"VAR.SEP":RELATION.STARTING.DATE:"VAR.SEP":SECTOR:"VAR.SEP":MAIN.ECONOMIC.ACTIVITY:"VAR.SEP":GROUP.RISK
***************                     14                        15            16        17               18                19              20                 21
    CUS.DET.ARR:= "VAR.SEP":EXECUTIVE.RESPONSIBLE:"VAR.SEP":ADDRESS.TYPE:"VAR.SEP":COUNTRY:"VAR.SEP":PROVINCE:"VAR.SEP":CITY:"VAR.SEP":SECTOR.2:"VAR.SEP":URB.ENS.RES
***************               21                   22                    23                 24              25             26              27             28              29
    CUS.DET.ARR:= "VAR.SEP":STREET:"VAR.SEP":NUMBER.SUITABLE:"VAR.SEP":ZIP.CODE:"VAR.SEP":PO.BOX:"VAR.SEP":TYPE:"VAR.SEP":AREA:"VAR.SEP":NUMBER:"VAR.SEP":EXT:"VAR.SEP":CONTACT
*************                     30                        31                      32                         33                           34                          35                    36
    CUS.DET.ARR:= "VAR.SEP":CUS.CORPORATE.NAME:"VAR.SEP":CUS.ID.NR:"VAR.SEP":CUS.PARTICIPATION:"VAR.SEP":DATE.CONSTITUTE.ASS:"VAR.SEP":SHA.CORPORATE.NAME:"VAR.SEP":SHA.ID.NR:"VAR.SEP":SHA.PARTICIPATION
************                    37                      38                    39                        40                   41                   42                  43                      44                      45
    CUS.DET.ARR:= "VAR.SEP":FIN.INST.ONE:"VAR.SEP":FIN.INST.TWO:"VAR.SEP":FIN.INST.THREE:"VAR.SEP":FIN.INST.FOUR:"VAR.SEP":SEGMENTO:"VAR.SEP":VAR.ACCOUNT:"VAR.SEP":PRODUCT.CODE:"VAR.SEP":DEPOSIT.SOURCE:"VAR.SEP":TOT.DEP
************                   46                47                 48                  49                  50                 51                   52                  53                54
    CUS.DET.ARR:= "VAR.SEP":DEP.CASH:"VAR.SEP":DEP.CHQ:"VAR.SEP":DEP.TRANS:"VAR.SEP":TOT.WITHD:"VAR.SEP":WITH.CASH:"VAR.SEP":WITH.CHQ:"VAR.SEP":WITH.TRANS:"VAR.SEP":DEP.QTY:"VAR.SEP":WITH.QTY
**********                     55                   56    J57
    CUS.DET.ARR:= "VAR.SEP":Y.PROP.USE:"VAR.SEP":FUND.ORIGIN:"VAR.SEP":JAVA.BUNCH.SET


RETURN
*------------------------------------------------------------------------------------------------------
GET.ACCOUNT.DETAILS:
*------------------------------------------------------------------------------------------------------
*This para is used to get the account details with in range of  1000 and 1999 category
    LOOP
        REMOVE Y.AC.ID FROM R.CUS.ACC SETTING POS.AC
    WHILE Y.AC.ID:POS.AC
        LOCATE Y.AC.ID IN R.AZ.CUS.ACC SETTING POS.AZ ELSE
            CALL F.READ(FN.ACCOUNT,Y.AC.ID,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
            PROD.CODE = R.ACCOUNT<AC.CATEGORY>
            LOCATE PROD.CODE IN VAR.RE.INV.CATEG SETTING POS.RE ELSE
                IF (PROD.CODE GE 1000 AND PROD.CODE LE 1999) OR (PROD.CODE GE 6000 AND PROD.CODE LE 6599) THEN
                    GOSUB CATEG.DESC
                    PRODUCT.CODE<1,-1> = PROD.CODE.DESC
                    VAR.ACCOUNT<1,-1> = Y.AC.ID
                    DEP.CODE           = R.ACCOUNT<AC.LOCAL.REF,Y.POS.AC.SRCNI>
                    GOSUB CHK.DEP.CODE
                    GOSUB DEP.WITHDR
                    PROP.USE = R.ACCOUNT<AC.LOCAL.REF,Y.POS.PROP.USE>
                    GOSUB CHK.PR.USE
                    VAL.FUND.ORIGIN =  R.ACCOUNT<AC.LOCAL.REF,Y.POS.FUND.ORIGIN>
                    GOSUB CHK.FUND.ORIGIN
                END
            END
        END
    REPEAT
RETURN
*--------------------------------------------------------------------------------------------------
GET.AZACC.DETAILS:
*---------------------------------------------------------------------------------------------------
    LOOP
        REMOVE Y.AZ.AC.ID FROM R.AZ.CUS.ACC SETTING POS.AZ.ACC
    WHILE Y.AZ.AC.ID:POS.AZ.ACC
        CALL F.READ(FN.AZ.ACCOUNT,Y.AZ.AC.ID,R.AZ.ACCOUNT,F.AZ.ACCOUNT,AZ.ACC.ERR)
        PROD.CODE = R.AZ.ACCOUNT<AZ.CATEGORY>
        IF PROD.CODE GE 6600 AND PROD.CODE LE 6699 THEN
            GOSUB CATEG.DESC
            PRODUCT.CODE<1,-1> = PROD.CODE.DESC
            VAR.ACCOUNT<1,-1> = Y.AZ.AC.ID
            DEP.CODE           = R.AZ.ACCOUNT<AZ.LOCAL.REF,Y.POS.AZ.SRCINI>
            GOSUB CHK.DEP.CODE
            TOT.DEP<1,-1> = 'N/A'   ; DEP.CASH<1,-1> = 'N/A'  ; DEP.CHQ<1,-1> = 'N/A'  ; DEP.TRANS<1,-1> = 'N/A'
            TOT.WITHD<1,-1> = 'N/A' ; WITH.CASH<1,-1> = 'N/A' ; WITH.CHQ<1,-1> = 'N/A' ; WITH.TRANS<1,-1> =  'N/A'
            DEP.QTY<1,-1> = 'N/A'   ; WITH.QTY<1,-1> = 'N/A'
            PROP.USE = R.AZ.ACCOUNT<AZ.LOCAL.REF,Y.POS.AZ.PROP>
            GOSUB CHK.PR.USE
            VAL.FUND.ORIGIN =  R.AZ.ACCOUNT<AZ.LOCAL.REF,Y.POS.AZ.FUND>
            GOSUB CHK.FUND.ORIGIN
        END
    REPEAT
RETURN
*---------------------------------------------------------------------------
CHK.DEP.CODE:
*----------------------------------------------------------------------------
    IF DEP.CODE THEN
        GOSUB AC.SRCINI
        DEPOSIT.SOURCE<1,-1> = VAR.DEPOSIT.SOURCE
    END ELSE
        DEPOSIT.SOURCE<1,-1> = 'N/A'
    END
RETURN
*----------------------------------------------------------------------------
AC.SRCINI:
*-----------------------------------------------------------------------------
    CNT.SRC = DCOUNT(DEP.CODE,@SM) ; COUNT.SRC = 1   ; VAR.DEPOSIT.SOURCE = ''
    LOOP
    WHILE COUNT.SRC LE CNT.SRC
        VAR.DEP.CODE = DEP.CODE<1,1,COUNT.SRC>
        LOCATE VAR.DEP.CODE IN Y.LOOKUP.LIST11 SETTING POS11 THEN
            VAL.DEP.CODE = ''
            VAL.DEP.CODE = Y.LOOKUP.DESC11<POS11,VAR.USER.LANG>
            IF NOT(VAL.DEP.CODE) THEN
                VAR.DEPOSIT.SOURCE<1,1,-1> = Y.LOOKUP.DESC11<POS11,1>
            END ELSE
                VAR.DEPOSIT.SOURCE<1,1,-1> = VAL.DEP.CODE
            END
        END
        COUNT.SRC += 1
    REPEAT
RETURN
*--------------------------------------------------------------------------------------------------
DEP.WITHDR:
*--------------------------------------------------------------------------------------------------
    GOSUB CHK.DEP.AMT
    GOSUB CHK.WITHDR.AMT
    GOSUB CHK.DEP.WITH.QTY

RETURN
*------------------------------------------------------------------------------------------------------
CHK.DEP.AMT:
*------------------------------------------------------------------------------------------------------
    VAR.TOT.DEP     = R.ACCOUNT<AC.LOCAL.REF,TOT.DEP.POS>
    IF VAR.TOT.DEP THEN
        TOT.DEP<1,-1> = VAR.TOT.DEP
    END ELSE
        TOT.DEP<1,-1> = 'N/A'
    END

    VAR.DEP.CASH = R.ACCOUNT<AC.LOCAL.REF,Y.POS.DEP.CASH>
    LOCATE VAR.DEP.CASH IN Y.LOOKUP.LIST1 SETTING POS1 THEN
        DEP.CASH<1,-1> = Y.LOOKUP.DESC1<POS1>
    END ELSE
        DEP.CASH<1,-1> = 'N/A'
    END

    VAR.DEP.CHQ = R.ACCOUNT<AC.LOCAL.REF,Y.POS.DEP.CHQ>
    LOCATE VAR.DEP.CHQ IN Y.LOOKUP.LIST2 SETTING POS2 THEN
        DEP.CHQ<1,-1> = Y.LOOKUP.DESC2<POS2>
    END ELSE
        DEP.CHQ<1,-1> = 'N/A'
    END

    VAR.DEP.TRANS = R.ACCOUNT<AC.LOCAL.REF,Y.POS.DEP.TR>
    LOCATE VAR.DEP.TRANS IN Y.LOOKUP.LIST3 SETTING POS3 THEN
        DEP.TRANS<1,-1> = Y.LOOKUP.DESC3<POS3>
    END ELSE
        DEP.TRANS<1,-1> = 'N/A'
    END

RETURN
*------------------------------------------------------------------------------------------------------------
CHK.WITHDR.AMT:
*-----------------------------------------------------------------------------------------------------------
    VAR.TOT.WITHD  = R.ACCOUNT<AC.LOCAL.REF,TOT.WITHD.POS>
    IF VAR.TOT.WITHD THEN
        TOT.WITHD<1,-1> = VAR.TOT.WITHD
    END ELSE
        TOT.WITHD<1,-1> = 'N/A'
    END

    VAR.WITH.CASH = R.ACCOUNT<AC.LOCAL.REF,Y.POS.WITH.CASH>
    LOCATE VAR.WITH.CASH IN Y.LOOKUP.LIST4 SETTING POS4 THEN
        WITH.CASH<1,-1> =  Y.LOOKUP.DESC4<POS4>
    END ELSE
        WITH.CASH<1,-1> = 'N/A'
    END

    VAR.WITH.CHQ = R.ACCOUNT<AC.LOCAL.REF,Y.POS.WITH.CHQ>
    LOCATE VAR.WITH.CHQ IN Y.LOOKUP.LIST5 SETTING POS5 THEN
        WITH.CHQ<1,-1> = Y.LOOKUP.DESC5<POS5>
    END ELSE
        WITH.CHQ<1,-1> = 'N/A'
    END

    VAR.WITH.TRANS = R.ACCOUNT<AC.LOCAL.REF,Y.POS.WITH.TR>
    LOCATE VAR.WITH.TRANS IN Y.LOOKUP.LIST6 SETTING POS6 THEN
        WITH.TRANS<1,-1> =  Y.LOOKUP.DESC6<POS6>
    END ELSE
        WITH.TRANS<1,-1> = 'N/A'
    END
RETURN
*------------------------------------------------------------------------------------------------------------
CHK.DEP.WITH.QTY:
*------------------------------------------------------------------------------------------------------------
    VAR.DEP.QTY =R.ACCOUNT<AC.LOCAL.REF,Y.POS.QTY.DEP>
    IF VAR.DEP.QTY THEN
        DEP.QTY<1,-1> = VAR.DEP.QTY
    END ELSE
        DEP.QTY<1,-1> = 'N/A'
    END

    VAR.WITH.QTY  = R.ACCOUNT<AC.LOCAL.REF,Y.POS.QTY.WITH>
    IF VAR.WITH.QTY THEN
        WITH.QTY<1,-1> = R.ACCOUNT<AC.LOCAL.REF,Y.POS.QTY.WITH>
    END ELSE
        WITH.QTY<1,-1> = 'N/A'
    END
RETURN
*----------------------------------------------------------------------------------------------------
CHK.PR.USE:
*----------------------------------------------------------------------------------------------------

    LOCATE PROP.USE IN Y.LOOKUP.LIST12 SETTING POS12 THEN
        VAL.PROP.USE = ''
        VAL.PROP.USE = Y.LOOKUP.DESC12<POS12,VAR.USER.LANG>
        IF NOT(VAL.PROP.USE) THEN
            Y.PROP.USE<1,-1> = Y.LOOKUP.DESC12<POS12,1>
        END ELSE
            Y.PROP.USE<1,-1> = VAL.PROP.USE
        END
    END ELSE
        Y.PROP.USE<1,-1> = 'N/A'
    END
RETURN
*--------------------------------------------------------------------------------------------------------
CHK.FUND.ORIGIN:
*--------------------------------------------------------------------------------------------------------
    IF VAL.FUND.ORIGIN THEN
        FUND.ORIGIN<1,-1> = VAL.FUND.ORIGIN
    END ELSE
        FUND.ORIGIN<1,-1> = 'N/A'
    END
RETURN
*----------------------------------------------------------------------------------------------------
CATEG.DESC:
*-----------------------------------------------------------------------------------------------------
    CALL CACHE.READ(FN.CATEGORY, PROD.CODE, R.CATEG, CATEG.ERR)  ;*R22 Auto Conversion  - F.READ to CACHE.READ
    PROD.CODE.DESC = R.CATEG<EB.CAT.DESCRIPTION,VAR.USER.LANG>
    IF NOT(PROD.CODE.DESC) THEN
        PROD.CODE.DESC = R.CATEG<EB.CAT.DESCRIPTION,1>
    END
RETURN
*---------------------------------------------------------------------------------------------------
GET.VALUES:
*----------------------------------------------------------------------------------------------------
*This para is used to get the values from EB.LOOKUP table
    VIRTUAL.TAB.ID1='L.AC.CASH.DEP'
    CALL EB.LOOKUP.LIST(VIRTUAL.TAB.ID1)
    Y.LOOKUP.LIST1=VIRTUAL.TAB.ID1<2>
    DESC.CNT =DCOUNT(VIRTUAL.TAB.ID1,@FM)
    Y.LOOKUP.DESC1=VIRTUAL.TAB.ID1<DESC.CNT>
    CHANGE '_' TO @FM IN Y.LOOKUP.LIST1
    CHANGE '_' TO @FM IN Y.LOOKUP.DESC1

    VIRTUAL.TAB.ID2='L.AC.CHQ.DEP'
    CALL EB.LOOKUP.LIST(VIRTUAL.TAB.ID2)
    Y.LOOKUP.LIST2=VIRTUAL.TAB.ID2<2>
    DESC.CNT =DCOUNT(VIRTUAL.TAB.ID2,@FM)
    Y.LOOKUP.DESC2=VIRTUAL.TAB.ID2<DESC.CNT>
    CHANGE '_' TO @FM IN Y.LOOKUP.LIST2
    CHANGE '_' TO @FM IN Y.LOOKUP.DESC2

    VIRTUAL.TAB.ID3='L.AC.TRANS.DEP'
    CALL EB.LOOKUP.LIST(VIRTUAL.TAB.ID3)
    Y.LOOKUP.LIST3=VIRTUAL.TAB.ID3<2>
    DESC.CNT =DCOUNT(VIRTUAL.TAB.ID3,@FM)
    Y.LOOKUP.DESC3=VIRTUAL.TAB.ID1<DESC.CNT>
    CHANGE '_' TO @FM IN Y.LOOKUP.LIST3
    CHANGE '_' TO @FM IN Y.LOOKUP.DESC3

    VIRTUAL.TAB.ID4='L.AC.CASHWITHDR'
    CALL EB.LOOKUP.LIST(VIRTUAL.TAB.ID4)
    Y.LOOKUP.LIST4=VIRTUAL.TAB.ID4<2>
    DESC.CNT =DCOUNT(VIRTUAL.TAB.ID4,@FM)
    Y.LOOKUP.DESC4=VIRTUAL.TAB.ID4<DESC.CNT>
    CHANGE '_' TO @FM IN Y.LOOKUP.LIST4
    CHANGE '_' TO @FM IN Y.LOOKUP.DESC4

    VIRTUAL.TAB.ID5='L.AC.CHQWITHDR'
    CALL EB.LOOKUP.LIST(VIRTUAL.TAB.ID5)
    Y.LOOKUP.LIST5=VIRTUAL.TAB.ID5<2>
    DESC.CNT =DCOUNT(VIRTUAL.TAB.ID5,@FM)
    Y.LOOKUP.DESC5=VIRTUAL.TAB.ID5<DESC.CNT>
    CHANGE '_' TO @FM IN Y.LOOKUP.LIST5
    CHANGE '_' TO @FM IN Y.LOOKUP.DESC5

    VIRTUAL.TAB.ID6='L.AC.TRANS.WDR'
    CALL EB.LOOKUP.LIST(VIRTUAL.TAB.ID6)
    Y.LOOKUP.LIST6=VIRTUAL.TAB.ID6<2>
    DESC.CNT =DCOUNT(VIRTUAL.TAB.ID6,@FM)
    Y.LOOKUP.DESC6=VIRTUAL.TAB.ID6<DESC.CNT>
    CHANGE '_' TO @FM IN Y.LOOKUP.LIST6
    CHANGE '_' TO @FM IN Y.LOOKUP.DESC6

    VIRTUAL.TAB.ID7='GENDER'
    CALL EB.LOOKUP.LIST(VIRTUAL.TAB.ID7)
    Y.LOOKUP.LIST7=VIRTUAL.TAB.ID7<2>
    DESC.CNT =DCOUNT(VIRTUAL.TAB.ID7,@FM)
    Y.LOOKUP.DESC7=VIRTUAL.TAB.ID7<DESC.CNT>
    CHANGE '_' TO @FM IN Y.LOOKUP.LIST7
    CHANGE '_' TO @FM IN Y.LOOKUP.DESC7

    VIRTUAL.TAB.ID8='MARITAL.STATUS'
    CALL EB.LOOKUP.LIST(VIRTUAL.TAB.ID8)
    Y.LOOKUP.LIST8=VIRTUAL.TAB.ID8<2>
    DESC.CNT =DCOUNT(VIRTUAL.TAB.ID8,@FM)
    Y.LOOKUP.DESC8=VIRTUAL.TAB.ID8<DESC.CNT>
    CHANGE '_' TO @FM IN Y.LOOKUP.LIST8
    CHANGE '_' TO @FM IN Y.LOOKUP.DESC8

    VIRTUAL.TAB.ID9='EMPLOYMENT.STATUS'
    CALL EB.LOOKUP.LIST(VIRTUAL.TAB.ID9)
    Y.LOOKUP.LIST9=VIRTUAL.TAB.ID9<2>
    DESC.CNT =DCOUNT(VIRTUAL.TAB.ID9,@FM)
    Y.LOOKUP.DESC9=VIRTUAL.TAB.ID9<DESC.CNT>
    CHANGE '_' TO @FM IN Y.LOOKUP.LIST9
    CHANGE '_' TO @FM IN Y.LOOKUP.DESC9

    VIRTUAL.TAB.ID10='RESIDENCE.TYPE'
    CALL EB.LOOKUP.LIST(VIRTUAL.TAB.ID10)
    Y.LOOKUP.LIST10=VIRTUAL.TAB.ID10<2>
    DESC.CNT =DCOUNT(VIRTUAL.TAB.ID10,@FM)
    Y.LOOKUP.DESC10=VIRTUAL.TAB.ID10<DESC.CNT>
    CHANGE '_' TO @FM IN Y.LOOKUP.LIST10
    CHANGE '_' TO @FM IN Y.LOOKUP.DESC10

    VIRTUAL.TAB.ID11='L.AC.SRCINITDEP'
    CALL EB.LOOKUP.LIST(VIRTUAL.TAB.ID11)
    Y.LOOKUP.LIST11=VIRTUAL.TAB.ID11<2>
    DESC.CNT =DCOUNT(VIRTUAL.TAB.ID11,@FM)
    Y.LOOKUP.DESC11=VIRTUAL.TAB.ID11<DESC.CNT>
    CHANGE '_' TO @FM IN Y.LOOKUP.LIST11
    CHANGE '_' TO @FM IN Y.LOOKUP.DESC11

    VIRTUAL.TAB.ID12='L.AC.PROP.USE'
    CALL EB.LOOKUP.LIST(VIRTUAL.TAB.ID12)
    Y.LOOKUP.LIST12=VIRTUAL.TAB.ID12<2>
    DESC.CNT =DCOUNT(VIRTUAL.TAB.ID12,@FM)
    Y.LOOKUP.DESC12=VIRTUAL.TAB.ID12<DESC.CNT>
    CHANGE '_' TO @FM IN Y.LOOKUP.LIST12
    CHANGE '_' TO @FM IN Y.LOOKUP.DESC12
*PACS00023993 - E
RETURN
*-------------------------------------------------------------------------------------------------------
END
