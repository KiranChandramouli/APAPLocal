* @ValidationCode : Mjo0OTU3OTc1MjQ6Q3AxMjUyOjE2ODExNTE2MTc4Mjk6SVRTUzotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 11 Apr 2023 00:03:37
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.VAL.FR.COMP.CUST
*-----------------------------------------------------------------------------
*----------------------------------------------------------------------------------------------------
*DESCRIPTION : This validation routine is used to display the accounts of a selected customer in a drop-down list
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : SUDHARSANAN S
* PROGRAM NAME : REDO.VAL.ISSUE.COMP.CUST
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO              REFERENCE         DESCRIPTION
* *01-MAR-2010    PRABHU            HD1100464         INITIAL CREATION
* 11.05.2011      PRADEEP S         PACS00060849      Changed the mapping for Customer names
* 11.04.2023     Conversion Tool       R22            Auto Conversion     - ++ TO += 1, VM TO @VM, SM TO @SM
* 11.04.2023     Shanmugapriya M       R22            Manual Conversion   - No changes
*
* ----------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.REDO.FRONT.COMPLAINTS
    $INSERT I_F.CUSTOMER
    $INSERT I_F.CUSTOMER.ACCOUNT

    IF VAL.TEXT THEN
        IF AF EQ FR.CM.DATA.CONFIRMED  AND COMI NE 'YES' THEN
            ETEXT ='EB-REDO.CUSTOMER.DATA.CONFIRMED'
            CALL STORE.END.ERROR
        END
        RETURN
    END
    GOSUB INIT
    GOSUB UPDATE.VALUE
RETURN
*------------------------------------------------------------------------------------------------------
INIT:
*------------------------------------------------------------------------------------------------------
    FN.CUSTOMER='F.CUSTOMER'
    F.CUSTOMER=''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
    FN.CUSTOMER.ACCOUNT='F.CUSTOMER.ACCOUNT'
    F.CUSTOMER.ACCOUNT = ''
    CALL OPF(FN.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT)
    FN.REDO.FRONT.COMPLAINTS = 'F.REDO.FRONT.COMPLAINTS'
    F.REDO.FRONT.COMPLAINTS  = ''
    CALL OPF(FN.REDO.FRONT.COMPLAINTS, F.REDO.FRONT.COMPLAINTS)

    FLAG =''
    R.NEW(FR.CM.GIVEN.NAMES)     =''
    R.NEW(FR.CM.FAMILY.NAMES)    =''
    R.NEW(FR.CM.SOCIAL.NAME)     =''
    R.NEW(FR.CM.RESIDENCE.TYPE)  =''
    R.NEW(FR.CM.RESIDENCE)       =''
    R.NEW(FR.CM.TOWN.COUNTRY)    =''
    R.NEW(FR.CM.COUNTRY)         =''
    R.NEW(FR.CM.L.CU.RES.SECTOR) =''
    R.NEW(FR.CM.L.CU.URB.ENS.REC)=''
    R.NEW(FR.CM.STREET)          =''
    R.NEW(FR.CM.ADDRESS)         =''
    R.NEW(FR.CM.OFF.PHONE)       =''
    R.NEW(FR.CM.POST.CODE)       =''
    R.NEW(FR.CM.L.CU.TEL.TYPE)   =''
    R.NEW(FR.CM.L.CU.TEL.AREA)   =''
    R.NEW(FR.CM.L.CU.TEL.NO)     =''
    R.NEW(FR.CM.L.CU.TEL.EXT)    =''
    R.NEW(FR.CM.L.CU.TEL.P.CONT) =''
    R.NEW(FR.CM.EMAIL)           =''
    R.NEW(FR.CM.BRANCH)          =''
    R.NEW(FR.CM.CUST.ID.NUMBER)  =''
    R.NEW(FR.CM.ACCOUNT.OFFICER) =''

    LOC.REF.APPLICATION="CUSTOMER"
    LOC.REF.FIELDS='L.CU.URB.ENS.RE':@VM:'L.CU.TEL.TYPE':@VM:'L.CU.TEL.AREA':@VM:'L.CU.TEL.NO':@VM:'L.CU.TEL.EXT':@VM:'L.CU.TEL.P.CONT':@VM:'L.CU.CIDENT':@VM:'L.CU.RNC':@VM:'L.CU.NOUNICO':@VM:'L.CU.ACTANAC':@VM:'L.CU.RES.SECTOR':@VM:'L.CU.TIPO.CL'
    LOC.REF.POS=''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    POS.L.CU.URB.ENS.RE=LOC.REF.POS<1,1>
    POS.L.CU.TEL.TYPE  =LOC.REF.POS<1,2>
    POS.L.CU.TEL.AREA  =LOC.REF.POS<1,3>
    POS.L.CU.TEL.NO    =LOC.REF.POS<1,4>
    POS.L.CU.TEL.EXT   =LOC.REF.POS<1,5>
    POS.L.CU.TEL.P.CONT =LOC.REF.POS<1,6>
    POS.L.CU.CIDENT    =LOC.REF.POS<1,7>
    POS.L.CU.RNC       =LOC.REF.POS<1,8>
    POS.L.CU.NOUNICO   =LOC.REF.POS<1,9>
    POS.L.CU.ACTANAC   =LOC.REF.POS<1,10>
    POS.L.CU.RES.SECTOR    =LOC.REF.POS<1,11>
    POS.L.CU.TIPO.CL = LOC.REF.POS<1,12>
RETURN
*--------------------------------------------------------------------------------------------------------
UPDATE.VALUE:
*--------------------------------------------------------------------------------------------------------

*Mapping field values based on the customer ID
    IF AF EQ FR.CM.CUSTOMER.CODE THEN
        CUS.ID = COMI
        GOSUB LAUNCH.ENQUIRY
    END
    IF AF EQ FR.CM.DATA.CONFIRMED  AND COMI EQ 'YES' THEN
        CUS.ID=R.NEW(FR.CM.CUSTOMER.CODE)
        GOSUB UPDATE.DATA
    END
RETURN
*----------------------------------------------------------------------------------------------------------
LAUNCH.ENQUIRY:
*------------------------------------------------------------------------------------------------------------
    IF VAL.TEXT EQ '' THEN
        TASK.NAME = 'ENQ REDO.CRM @ID EQ ': CUS.ID
        CALL EB.SET.NEW.TASK(TASK.NAME)
    END
RETURN
*-------------------------------------------------------------------------------------------------------------
UPDATE.DATA:
*------------------------------------------------------------------------------------------------------------
    CALL F.READ(FN.CUSTOMER,CUS.ID,R.CUSTOMER,F.CUSTOMER,CUS.ERR)
    GOSUB CUS.UPDATE

*PACS00060849 - S

    Y.TIPO.CL = R.CUSTOMER<EB.CUS.LOCAL.REF,POS.L.CU.TIPO.CL>
    IF Y.TIPO.CL EQ "PERSONA JURIDICA"  THEN
        R.NEW(FR.CM.SOCIAL.NAME) = R.CUSTOMER<EB.CUS.NAME.1>:" ":R.CUSTOMER<EB.CUS.NAME.2>
    END

    IF Y.TIPO.CL EQ "PERSONA FISICA" OR Y.TIPO.CL EQ "PERSONA MENOR" THEN
        R.NEW(FR.CM.GIVEN.NAMES)= R.CUSTOMER<EB.CUS.GIVEN.NAMES>
        R.NEW(FR.CM.FAMILY.NAMES)= R.CUSTOMER<EB.CUS.FAMILY.NAME>
    END
*PACS00060849 - E

    RES.LIST=DCOUNT(R.CUSTOMER<EB.CUS.RESIDENCE.TYPE>,@VM)
    RES.CNT = 1
    LOOP
    WHILE RES.CNT LE RES.LIST
        R.NEW(FR.CM.RESIDENCE.TYPE)<1,RES.CNT> = R.CUSTOMER<EB.CUS.RESIDENCE.TYPE,RES.CNT>
        RES.CNT += 1             ;** R22 Auto conversion - ++ TO += 1
    REPEAT
    R.NEW(FR.CM.RESIDENCE) = R.CUSTOMER<EB.CUS.RESIDENCE>
    R.NEW(FR.CM.TOWN.COUNTRY) = R.CUSTOMER<EB.CUS.TOWN.COUNTRY>
    R.NEW(FR.CM.COUNTRY) = R.CUSTOMER<EB.CUS.COUNTRY>
    R.NEW(FR.CM.L.CU.RES.SECTOR) = R.CUSTOMER<EB.CUS.LOCAL.REF,POS.L.CU.RES.SECTOR>
    R.NEW(FR.CM.L.CU.URB.ENS.REC) = R.CUSTOMER<EB.CUS.LOCAL.REF,POS.L.CU.URB.ENS.RE>
    R.NEW(FR.CM.STREET) = R.CUSTOMER<EB.CUS.STREET>
    ADD.LIST = DCOUNT(R.CUSTOMER<EB.CUS.ADDRESS>,@VM)
    ADD.CNT = 1
    LOOP
    WHILE ADD.CNT LE ADD.LIST
        R.NEW(FR.CM.ADDRESS)<1,ADD.CNT> = R.CUSTOMER<EB.CUS.ADDRESS,ADD.CNT>
        ADD.CNT += 1           ;** R22 Auto conversion - ++ TO += 1
    REPEAT
    OFF.LIST = DCOUNT(R.CUSTOMER<EB.CUS.OFF.PHONE>,@VM)
    OFF.CNT = 1                  ;** R22 Auto conversion - ++ TO += 1
    LOOP
    WHILE OFF.CNT LE OFF.LIST
        R.NEW(FR.CM.OFF.PHONE)<1,OFF.CNT> = R.CUSTOMER<EB.CUS.OFF.PHONE,OFF.CNT>
        OFF.CNT += 1
    REPEAT
    R.NEW(FR.CM.POST.CODE) = R.CUSTOMER<EB.CUS.POST.CODE>
    TEL.LIST = DCOUNT(R.CUSTOMER<EB.CUS.LOCAL.REF,POS.L.CU.TEL.TYPE>,@SM)
    TEL.CNT = 1
    LOOP
    WHILE TEL.CNT LE TEL.LIST
        R.NEW(FR.CM.L.CU.TEL.TYPE)<1,TEL.CNT> = R.CUSTOMER<EB.CUS.LOCAL.REF,POS.L.CU.TEL.TYPE,TEL.CNT>
        R.NEW(FR.CM.L.CU.TEL.AREA)<1,TEL.CNT>          = R.CUSTOMER<EB.CUS.LOCAL.REF,POS.L.CU.TEL.AREA,TEL.CNT>
        R.NEW(FR.CM.L.CU.TEL.NO)<1,TEL.CNT>    = R.CUSTOMER<EB.CUS.LOCAL.REF,POS.L.CU.TEL.NO,TEL.CNT>
        R.NEW(FR.CM.L.CU.TEL.EXT)<1,TEL.CNT>     = R.CUSTOMER<EB.CUS.LOCAL.REF,POS.L.CU.TEL.EXT,TEL.CNT>
        R.NEW(FR.CM.L.CU.TEL.P.CONT)<1,TEL.CNT>     = R.CUSTOMER<EB.CUS.LOCAL.REF,POS.L.CU.TEL.P.CONT,TEL.CNT>
        TEL.CNT += 1                ;** R22 Auto conversion - ++ TO += 1
    REPEAT
    MAIL.LIST=DCOUNT(R.CUSTOMER<EB.CUS.EMAIL.1>,@VM)
    MAIL.CNT = 1
    LOOP
    WHILE MAIL.CNT LE MAIL.LIST
        R.NEW(FR.CM.EMAIL)<1,MAIL.CNT> = R.CUSTOMER<EB.CUS.EMAIL.1,MAIL.CNT>
        MAIL.CNT += 1                ;** R22 Auto conversion - ++ TO += 1
    REPEAT
    R.NEW(FR.CM.BRANCH)          = R.CUSTOMER<EB.CUS.OTHER.OFFICER,1>
    R.NEW(FR.CM.ACCOUNT.OFFICER) = R.CUSTOMER<EB.CUS.ACCOUNT.OFFICER>
RETURN
*------------------------------------------------------------------------------------------------------------
CUS.UPDATE:
*-----------------------------------------------------------------------------------------------------------
    VAR.CIDENT = R.CUSTOMER<EB.CUS.LOCAL.REF,POS.L.CU.CIDENT>
    VAR.LEGAL.ID  = R.CUSTOMER<EB.CUS.LEGAL.ID,1>
    VAR.RNC =R.CUSTOMER<EB.CUS.LOCAL.REF,POS.L.CU.RNC>
    VAR.NOUN = R.CUSTOMER<EB.CUS.LOCAL.REF,POS.L.CU.NOUNICO>
    VAR.ACT = R.CUSTOMER<EB.CUS.LOCAL.REF,POS.L.CU.ACTANAC>
    IF VAR.CIDENT NE '' AND FLAG EQ '' THEN
        R.NEW(FR.CM.CUST.ID.NUMBER) = VAR.CIDENT
        FLAG = 1
    END
    IF VAR.LEGAL.ID NE '' AND FLAG EQ '' THEN
        R.NEW(FR.CM.CUST.ID.NUMBER) = VAR.LEGAL.ID
        FLAG = 1
    END
    IF VAR.RNC NE '' AND FLAG EQ '' THEN
        R.NEW(FR.CM.CUST.ID.NUMBER) = VAR.RNC
        FLAG = 1
    END
    IF VAR.NOUN NE '' AND FLAG EQ '' THEN
        R.NEW(FR.CM.CUST.ID.NUMBER) = VAR.NOUN
        FLAG = 1
    END
    IF VAR.ACT NE '' AND FLAG EQ '' THEN
        R.NEW(FR.CM.CUST.ID.NUMBER) = VAR.ACT
        FLAG = 1
    END
RETURN
*-----------------------------------------------------------------------------------------------------------
END
