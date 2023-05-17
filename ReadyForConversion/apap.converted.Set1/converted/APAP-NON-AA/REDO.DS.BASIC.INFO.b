SUBROUTINE REDO.DS.BASIC.INFO(CUST.ID,NAME.CORP,ID.CORP,ROLE.1)
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This development is for ODR Reference ODR-2010-04-0425
* This is field format routine for the deal slip
* This subroutine is to check and return the basic informations
* Input/Output:
*--------------
* IN : -NA-
* OUT : -NA-
* Dependencies:
*---------------
* CALLS : @ID
* CALLED BY : BASIC.INFO
* Revision History:
*------------------------------------------------------------------------------------------
*   Date               who           Reference            Description
* 25-Nov-2009       B.Renugadevi     ODR-2010-04-0425     Initial Creation
* 20-JUL-2011       S SUDHARSANAN     PACS00084100         Modify as per issue
*------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.EB.ROLE

    GOSUB INIT
    GOSUB PROCESS
RETURN
*****
INIT:
*****
    CUS.ID          = CUST.ID   ; NAME.CORP  = ''  ; ID.CORP    = '' ; ROLE.1     = ''
    COUNT.CODE = ''
    FN.CUSTOMER     = 'F.CUSTOMER'
    F.CUSTOMER      = ''
    R.REL.CUS       =''
    FN.ROLES        = "F.EB.ROLE"
    F.ROLES         = ''
    R.ROLES         = ''
    LREF.FLDS       = "L.CU.TIPO.CL":@VM:"L.CU.CIDENT":@VM:"L.CU.RNC":@VM:"L.CU.NOUNICO":@VM:"L.CU.ACTANAC"
    CUST.POS        = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
    CALL OPF(FN.ROLES,F.ROLES)

RETURN
********
PROCESS:
*********
    CALL MULTI.GET.LOC.REF('CUSTOMER',LREF.FLDS,CUST.POS)
    POS.TIPO.CL     = CUST.POS<1,1>
    POS.CIDENT      = CUST.POS<1,2>
    POS.RNC         = CUST.POS<1,3>
    POS.NOUNICO     = CUST.POS<1,4>
    POS.ACTANAC     = CUST.POS<1,5>
    CALL F.READ(FN.CUSTOMER,CUS.ID,R.CUSTOMER,F.CUSTOMER,CUS.ERR)
    REL.CODES=R.CUSTOMER<EB.CUS.RELATION.CODE>

    IF REL.CODES NE '' THEN
        COUNTER.CODE  = 1
        COUNT.CODE = DCOUNT(REL.CODES,@VM)
        LOOP
        WHILE COUNTER.CODE LE COUNT.CODE
            IF R.CUSTOMER<EB.CUS.RELATION.CODE,COUNTER.CODE> EQ '102' THEN
                ROLE.ID   = R.CUSTOMER<EB.CUS.ROLE,COUNTER.CODE>
                IF ROLE.ID THEN
                    CALL CACHE.READ(FN.ROLES, ROLE.ID, R.ROLES, ROL.ERR)
                    ROLE.1<1,-1> = R.ROLES<EB.ROLE.DESCRIPTION,1>
                END ELSE
                    ROLE.1<1,-1> = 'N/A'
                END
                GOSUB PROCESS.RELCUS
            END
            COUNTER.CODE + =1
        REPEAT
    END ELSE
        NAME.CORP  = ''
        ID.CORP    = ''
        ROLE.1     = ''
    END
RETURN
***************
PROCESS.RELCUS:
****************
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
    NAME.CORP<1,-1>       = R.REL.CUS<EB.CUS.GIVEN.NAMES>:" ":R.REL.CUS<EB.CUS.FAMILY.NAME>
    IF R.REL.CUS<EB.CUS.LOCAL.REF,POS.CIDENT> NE '' THEN
        ID.CORP<1,-1> = R.REL.CUS<EB.CUS.LOCAL.REF,POS.CIDENT>
    END ELSE
        IF R.REL.CUS<EB.CUS.LEGAL.ID> NE '' THEN
            ID.CORP<1,-1> = R.REL.CUS<EB.CUS.LEGAL.ID>
        END ELSE
            IF R.REL.CUS<EB.CUS.LOCAL.REF,POS.NOUNICO> NE '' THEN
                ID.CORP<1,-1> =    R.REL.CUS<EB.CUS.LOCAL.REF,POS.NOUNICO>
            END ELSE
                IF R.REL.CUS<EB.CUS.LOCAL.REF,POS.ACTANAC> NE '' THEN
                    ID.CORP<1,-1> =    R.REL.CUS<EB.CUS.LOCAL.REF,POS.ACTANAC>
                END
            END
        END
    END
RETURN
*****************
PROCESS.JURIDICA:
*****************
    NAME.CORP<1,-1> = R.REL.CUS<EB.CUS.NAME.1>:R.REL.CUS<EB.CUS.NAME.2>
    ID.CORP<1,-1> = R.REL.CUS<EB.CUS.LOCAL.REF,POS.RNC>
RETURN
END
*-----------------------------------------------------------------------------------------
