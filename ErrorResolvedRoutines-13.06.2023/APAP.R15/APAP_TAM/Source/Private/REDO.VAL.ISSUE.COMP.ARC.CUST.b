* @ValidationCode : MjotMTEwMTE4MjM3MTpDcDEyNTI6MTY4MzAyNDMzNTk5NTpJVFNTOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 02 May 2023 16:15:35
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

SUBROUTINE REDO.VAL.ISSUE.COMP.ARC.CUST
*-----------------------------------------------------------------------------
*----------------------------------------------------------------------------------------------------
*DESCRIPTION : This AUTOM.NEW.CONNTENT routine is used to display the accounts of a selected customer in a drop-down list
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : Sakthi Sellappillai
* PROGRAM NAME : REDO.VAL.ISSUE.COMP.ARC.CUST
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO                     REFERENCE         DESCRIPTION
* 22.07.2010      Sakthi Sellappillai     ODR-2009-08-0031   INITIAL CREATION
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*18/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION        VM TO @VM, SM TO @SM,++ TO +=, IF CONDITION ADDED
*18/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
* ----------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.REDO.ISSUE.CLAIMS
    $INSERT I_F.CUSTOMER
    $INSERT I_F.CUSTOMER.ACCOUNT
    $INSERT I_EB.EXTERNAL.COMMON
    $INSERT I_System
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
    FN.REDO.ISSUE.CLAIMS = 'F.REDO.ISSUE.CLAIMS'
    F.REDO.ISSUE.CLAIMS  = ''
    CALL OPF(FN.REDO.ISSUE.CLAIMS, F.REDO.ISSUE.CLAIMS)

    FLAG =''
    R.NEW(ISS.CL.GIVEN.NAMES)     =''
    R.NEW(ISS.CL.FAMILY.NAMES)    =''
    R.NEW(ISS.CL.SOCIAL.NAME)     =''
    R.NEW(ISS.CL.RESIDENCE.TYPE)  =''
    R.NEW(ISS.CL.RESIDENCE)       =''
    R.NEW(ISS.CL.TOWN.COUNTRY)    =''
    R.NEW(ISS.CL.COUNTRY)         =''
    R.NEW(ISS.CL.L.CU.RES.SECTOR) =''
    R.NEW(ISS.CL.L.CU.URB.ENS.REC)=''
    R.NEW(ISS.CL.STREET)          =''
    R.NEW(ISS.CL.ADDRESS)         =''
    R.NEW(ISS.CL.OFF.PHONE)       =''
    R.NEW(ISS.CL.POST.CODE)       =''
    R.NEW(ISS.CL.L.CU.TEL.TYPE)   =''
    R.NEW(ISS.CL.L.CU.TEL.AREA)   =''
    R.NEW(ISS.CL.L.CU.TEL.NO)     =''
    R.NEW(ISS.CL.L.CU.TEL.EXT)    =''
    R.NEW(ISS.CL.L.CU.TEL.P.CONT) =''
    R.NEW(ISS.CL.EMAIL)           =''
    R.NEW(ISS.CL.BRANCH)          =''
    R.NEW(ISS.CL.CUST.ID.NUMBER)  =''
    R.NEW(ISS.CL.ACCOUNT.OFFICER) =''

    LOC.REF.APPLICATION="CUSTOMER"
    LOC.REF.FIELDS='L.CU.URB.ENS.RE':@VM:'L.CU.TEL.TYPE':@VM:'L.CU.TEL.AREA':@VM:'L.CU.TEL.NO':@VM:'L.CU.TEL.EXT':@VM:'L.CU.TEL.P.CONT':@VM:'L.CU.CIDENT':@VM:'L.CU.RNC':@VM:'L.CU.NOUNICO':@VM:'L.CU.ACTANAC':@VM:'L.CU.RES.SECTOR'
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
RETURN
*--------------------------------------------------------------------------------------------------------
UPDATE.VALUE:
*--------------------------------------------------------------------------------------------------------
*Mapping field values based on the customer ID
    CUS.ID = System.getVariable("EXT.SMS.CUSTOMERS")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN ;*AUTO R22 CODE CONVERSION - START
        CUS.ID = ""
    END ;*AUTO R22 CODE CONVERSION - END
    GOSUB PROCESS1
RETURN
*----------------------------------------------------------------------------------------------------------
PROCESS1:
*------------------------------------------------------------------------------------------------------------
    CALL F.READ(FN.CUSTOMER,CUS.ID,R.CUSTOMER,F.CUSTOMER,CUS.ERR)
    R.NEW(ISS.CL.CUSTOMER.CODE) = CUS.ID
    GOSUB CUS.UPDATE
    R.NEW(ISS.CL.GIVEN.NAMES)= R.CUSTOMER<EB.CUS.GIVEN.NAMES>
    R.NEW(ISS.CL.FAMILY.NAMES)= R.CUSTOMER<EB.CUS.FAMILY.NAME>
    R.NEW(ISS.CL.SOCIAL.NAME) = R.CUSTOMER<EB.CUS.NAME.1>:" ":R.CUSTOMER<EB.CUS.NAME.2>
    RES.LIST=DCOUNT(R.CUSTOMER<EB.CUS.RESIDENCE.TYPE>,@VM)
    RES.CNT = 1
    LOOP
    WHILE RES.CNT LE RES.LIST
        R.NEW(ISS.CL.RESIDENCE.TYPE)<1,RES.CNT> = R.CUSTOMER<EB.CUS.RESIDENCE.TYPE,RES.CNT>
        RES.CNT += 1 ;*AUTO R22 CODE CONVERSION
    REPEAT
    R.NEW(ISS.CL.RESIDENCE) = R.CUSTOMER<EB.CUS.RESIDENCE>
    R.NEW(ISS.CL.TOWN.COUNTRY) = R.CUSTOMER<EB.CUS.TOWN.COUNTRY>
    R.NEW(ISS.CL.COUNTRY) = R.CUSTOMER<EB.CUS.COUNTRY>
    R.NEW(ISS.CL.L.CU.RES.SECTOR) = R.CUSTOMER<EB.CUS.LOCAL.REF,POS.L.CU.RES.SECTOR>
    R.NEW(ISS.CL.L.CU.URB.ENS.REC) = R.CUSTOMER<EB.CUS.LOCAL.REF,POS.L.CU.URB.ENS.RE>
    R.NEW(ISS.CL.STREET) = R.CUSTOMER<EB.CUS.STREET>
    ADD.LIST = DCOUNT(R.CUSTOMER<EB.CUS.ADDRESS>,@VM)
    ADD.CNT = 1
    LOOP
    WHILE ADD.CNT LE ADD.LIST
        R.NEW(ISS.CL.ADDRESS)<1,ADD.CNT> = R.CUSTOMER<EB.CUS.ADDRESS,ADD.CNT>
        ADD.CNT += 1 ;*AUTO R22 CODE CONVERSION
    REPEAT
    OFF.LIST = DCOUNT(R.CUSTOMER<EB.CUS.OFF.PHONE>,@VM)
    OFF.CNT = 1
    LOOP
    WHILE OFF.CNT LE OFF.LIST
        R.NEW(ISS.CL.OFF.PHONE)<1,OFF.CNT> = R.CUSTOMER<EB.CUS.OFF.PHONE,OFF.CNT>
        OFF.CNT += 1 ;*AUTO R22 CODE CONVERSION
    REPEAT
    R.NEW(ISS.CL.POST.CODE) = R.CUSTOMER<EB.CUS.POST.CODE>
    TEL.LIST = DCOUNT(R.CUSTOMER<EB.CUS.LOCAL.REF,POS.L.CU.TEL.TYPE>,@SM)
    TEL.CNT = 1
    LOOP
    WHILE TEL.CNT LE TEL.LIST
        R.NEW(ISS.CL.L.CU.TEL.TYPE)<1,TEL.CNT> = R.CUSTOMER<EB.CUS.LOCAL.REF,POS.L.CU.TEL.TYPE,TEL.CNT>
        R.NEW(ISS.CL.L.CU.TEL.AREA)<1,TEL.CNT>          = R.CUSTOMER<EB.CUS.LOCAL.REF,POS.L.CU.TEL.AREA,TEL.CNT>
        R.NEW(ISS.CL.L.CU.TEL.NO)<1,TEL.CNT>    = R.CUSTOMER<EB.CUS.LOCAL.REF,POS.L.CU.TEL.NO,TEL.CNT>
        R.NEW(ISS.CL.L.CU.TEL.EXT)<1,TEL.CNT>     = R.CUSTOMER<EB.CUS.LOCAL.REF,POS.L.CU.TEL.EXT,TEL.CNT>
        R.NEW(ISS.CL.L.CU.TEL.P.CONT)<1,TEL.CNT>     = R.CUSTOMER<EB.CUS.LOCAL.REF,POS.L.CU.TEL.P.CONT,TEL.CNT>
        TEL.CNT += 1 ;*AUTO R22 CODE CONVERSION
    REPEAT
    MAIL.LIST=DCOUNT(R.CUSTOMER<EB.CUS.EMAIL.1>,@VM)
    MAIL.CNT = 1
    LOOP
    WHILE MAIL.CNT LE MAIL.LIST
        R.NEW(ISS.CL.EMAIL)<1,MAIL.CNT> = R.CUSTOMER<EB.CUS.EMAIL.1,MAIL.CNT>
        MAIL.CNT += 1 ;*AUTO R22 CODE CONVERSION
    REPEAT
    R.NEW(ISS.CL.BRANCH)          = R.CUSTOMER<EB.CUS.OTHER.OFFICER,1>
    R.NEW(ISS.CL.ACCOUNT.OFFICER) = R.CUSTOMER<EB.CUS.ACCOUNT.OFFICER>
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
        R.NEW(ISS.CL.CUST.ID.NUMBER) = VAR.CIDENT
        FLAG = 1
    END
    IF VAR.LEGAL.ID NE '' AND FLAG EQ '' THEN
        R.NEW(ISS.CL.CUST.ID.NUMBER) = VAR.LEGAL.ID
        FLAG = 1
    END
    IF VAR.RNC NE '' AND FLAG EQ '' THEN
        R.NEW(ISS.CL.CUST.ID.NUMBER) = VAR.RNC
        FLAG = 1
    END
    IF VAR.NOUN NE '' AND FLAG EQ '' THEN
        R.NEW(ISS.CL.CUST.ID.NUMBER) = VAR.NOUN
        FLAG = 1
    END
    IF VAR.ACT NE '' AND FLAG EQ '' THEN
        R.NEW(ISS.CL.CUST.ID.NUMBER) = VAR.ACT
        FLAG = 1
    END
RETURN
*-----------------------------------------------------------------------------------------------------------
END
