SUBROUTINE REDO.DS.SPOUSE.DETAILS(CUST.ID,SPOUSE.IDENT,SPOUSE.ID,FAM.NAME,GIV.NAME)
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This development is for ODR Reference ODR-2010-04-0425
* and sends out the ID.NUM of the customer
* Input/Output:
*--------------
* IN : ACCOUNT.ID
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------------------------------------------------------------------
* Date who Reference Description
* 25-Nov-2009 B Renugadevi ODR-2010-04-0425 Initial Creation
*------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.RELATION.CUSTOMER

    GOSUB INIT
    GOSUB PROCESS

RETURN
******
INIT:
******
    CUS.ID = CUST.ID
    SPOUSE.IDENT = ''
    SPOUSE.ID = ''
    FAM.NAME = ''
    GIV.NAME = ''
    FLAG =1
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    FN.RELATION.CUSTOMER = 'F.RELATION.CUSTOMER'
    F.RELATION.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    CALL OPF(FN.RELATION.CUSTOMER,F.RELATION.CUSTOMER)
    CALL GET.LOC.REF('CUSTOMER','L.CU.CIDENT',CIDENT.POS)
RETURN
********
PROCESS:
********
    CALL F.READ(FN.RELATION.CUSTOMER,CUS.ID,R.RELATION.CUSTOMER,F.RELATION.CUSTOMER,CUS.ERR)
    IF R.RELATION.CUSTOMER THEN
        REL.CODES=R.RELATION.CUSTOMER<EB.RCU.IS.RELATION>
        REL.CUST = R.RELATION.CUSTOMER<EB.RCU.OF.CUSTOMER>
        GOSUB REL.CHECK
    END
RETURN
**********
REL.CHECK:
**********
    IF REL.CODES THEN
        CHANGE @VM TO @FM IN REL.CODES
        CHANGE @VM TO @FM IN REL.CUST
        FM.CNT = DCOUNT(REL.CODES,@FM) ; CNT = 1
        LOOP
        WHILE CNT LE FM.CNT
            LOCATE '7' IN REL.CODES,CNT SETTING POS.REL THEN
                REL.CUS = REL.CUST<POS.REL>
                GOSUB REL.CUSTOMER
                CNT = POS.REL+1
                FLAG = ''
            END ELSE
                CNT = FM.CNT+1
            END
        REPEAT
        IF FLAG EQ 1 THEN
            CNT =1
            LOOP
            WHILE CNT LE FM.CNT
                GOSUB CHECK.REL.CODES
            REPEAT
        END
    END
RETURN
********************
CHECK.REL.CODES:
*********************
    LOCATE '8' IN REL.CODES,CNT SETTING POS.REL THEN
        REL.CUS = REL.CUST<POS.REL>
        GOSUB REL.CUSTOMER
        CNT = POS.REL+1
    END ELSE
        CNT = FM.CNT+1
    END
RETURN
*************
REL.CUSTOMER:
*************
    CALL F.READ(FN.CUSTOMER,REL.CUS,R.REL.CUSTOMER,F.CUSTOMER,CUS.ERR)
    IF R.REL.CUSTOMER<EB.CUS.LOCAL.REF><1,CIDENT.POS> NE '' THEN
        SPOUSE.IDENT<1,-1> = 'CEDULA'
    END ELSE
        IF R.REL.CUSTOMER<EB.CUS.LEGAL.ID> NE '' THEN
            SPOUSE.IDENT<1,-1> = 'PASAPORTE'
        END ELSE
            SPOUSE.IDENT<1,-1> = ''
        END
    END
*
    IF R.REL.CUSTOMER<EB.CUS.LOCAL.REF><1,CIDENT.POS> NE '' THEN
        SPOUSE.ID<1,-1> = R.REL.CUSTOMER<EB.CUS.LOCAL.REF><1,CIDENT.POS>
    END ELSE
        IF R.REL.CUSTOMER<EB.CUS.LEGAL.ID> NE '' THEN
            SPOUSE.ID<1,-1> = R.REL.CUSTOMER<EB.CUS.LEGAL.ID>
        END ELSE
            SPOUSE.ID<1,-1> = ''
        END
    END
    FAM.NAME<1,-1> = R.REL.CUSTOMER<EB.CUS.FAMILY.NAME>
    GIV.NAME<1,-1> = R.REL.CUSTOMER<EB.CUS.GIVEN.NAMES>
RETURN
*----------------------------------------------------------------------------
END
