* @ValidationCode : MjotODQ0MTg1NDUyOkNwMTI1MjoxNjgxOTA1NjgxMDM3OklUU1M6LTE6LTE6MjY0OjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 19 Apr 2023 17:31:21
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 264
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*13-04-2023            CONVERSION TOOL                AUTO R22 CODE CONVERSION           VM TO @VM ,FM TO @FM
*13-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
SUBROUTINE REDO.DS.SHA.INFO(CUST.ID,SHA.NAME.CORP,SHA.ID.CORP,SHA.ROLE.1)
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This development is for ODR Reference ODR-2010-04-0425
* This subroutine is to check and return the basic informations
* Input/Output:
*--------------
* IN : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS : @ID
* CALLED BY : SHA.INFO
*
* Revision History:
*------------------------------------------------------------------------------------------
*   Date               who           Reference            Description
* 25-Nov-2009       B.Renugadevi     ODR-2010-04-0425      Initial Creation
*------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    GOSUB INIT
    GOSUB PROCESS
RETURN
******
INIT:
*****
    CUS.ID       = CUST.ID
    FN.CUSTOMER  = 'F.CUSTOMER'
    F.CUSTOMER   = ''
    R.REL.CUS    = ''
    SHA.NAME.CORP = '' ; SHA.ID.CORP = '' ; SHA.ROLE.1 = ''
    LREF.FLDS = "L.CU.TIPO.CL":@VM:"L.CU.CIDENT":@VM:"L.CU.RNC":@VM:"L.CU.NOUNICO":@VM:"L.CU.ACTANAC"
    CUST.POS  = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
RETURN
*********
PROCESS:
*********
    CALL MULTI.GET.LOC.REF('CUSTOMER',LREF.FLDS,CUST.POS)
    POS.TIPO.CL   = CUST.POS<1,1>
    POS.CIDENT    = CUST.POS<1,2>
    POS.RNC       = CUST.POS<1,3>
    POS.NOUNICO   = CUST.POS<1,4>
    POS.ACTANAC   = CUST.POS<1,5>

    CALL F.READ(FN.CUSTOMER,CUS.ID,R.CUSTOMER,F.CUSTOMER,CUS.ERR)
    REL.CODES   =  R.CUSTOMER<EB.CUS.RELATION.CODE>
    IF REL.CODES NE '' THEN
        COUNT.CODE      = DCOUNT(REL.CODES,@VM)
        COUNTER.CODE    = 1
        LOOP
        WHILE COUNTER.CODE LE COUNT.CODE
            IF R.CUSTOMER<EB.CUS.RELATION.CODE,COUNTER.CODE> EQ '100' THEN
                CHK.SHA.ROLE = R.CUSTOMER<EB.CUS.ROLE.MORE.INFO,COUNTER.CODE>
                IF CHK.SHA.ROLE THEN
                    SHA.ROLE.1<1,-1>    = CHK.SHA.ROLE
                END ELSE
                    SHA.ROLE.1<1,-1> = 'N/A'
                END
                GOSUB PROCESS.RELCUS
            END
            COUNTER.CODE + =1
        REPEAT
    END
RETURN
***************
PROCESS.RELCUS:
***************
    REL.CUST = R.CUSTOMER<EB.CUS.REL.CUSTOMER,COUNTER.CODE>
    CALL F.READ(FN.CUSTOMER,REL.CUST,R.REL.CUS,F.CUSTOMER,ERR.CUS)
    IF R.REL.CUS THEN
        IF R.REL.CUS<EB.CUS.LOCAL.REF,POS.TIPO.CL> NE 'PERSONA JURIDICA' THEN
            GOSUB PROCESS.FISICA
        END ELSE
            GOSUB PROCESS.JURIDICA
        END
    END
RETURN
***************
PROCESS.FISICA:
***************
    SHA.NAME.CORP<1,-1>  = R.REL.CUS<EB.CUS.GIVEN.NAMES>:" ":R.REL.CUS<EB.CUS.FAMILY.NAME>
    IF R.REL.CUS<EB.CUS.LOCAL.REF,POS.CIDENT> NE '' THEN
        SHA.ID.CORP<1,-1> = R.REL.CUS<EB.CUS.LOCAL.REF,POS.CIDENT>
    END ELSE
        IF R.REL.CUS<EB.CUS.LEGAL.ID> NE '' THEN
            SHA.ID.CORP<1,-1> =R.REL.CUS<EB.CUS.LEGAL.ID>
        END ELSE
            IF R.REL.CUS<EB.CUS.LOCAL.REF,POS.NOUNICO> NE '' THEN
                SHA.ID.CORP<1,-1> =    R.REL.CUS<EB.CUS.LOCAL.REF,POS.NOUNICO>
            END ELSE
                IF R.REL.CUS<EB.CUS.LOCAL.REF,POS.ACTANAC> NE '' THEN
                    SHA.ID.CORP<1,-1> =    R.REL.CUS<EB.CUS.LOCAL.REF,POS.ACTANAC>
                END
            END
        END
    END
RETURN
*****************
PROCESS.JURIDICA:
*****************
    SHA.NAME.CORP<1,-1>  = R.REL.CUS<EB.CUS.NAME.1>:R.REL.CUS<EB.CUS.NAME.2>
    SHA.ID.CORP<1,-1> = R.REL.CUS<EB.CUS.LOCAL.REF,POS.RNC>
RETURN
END
*-----------------------------------------------------------------------------------------
