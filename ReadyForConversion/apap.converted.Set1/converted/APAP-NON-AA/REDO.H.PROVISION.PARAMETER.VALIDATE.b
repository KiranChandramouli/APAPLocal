SUBROUTINE REDO.H.PROVISION.PARAMETER.VALIDATE
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.H.PROVISION.PARAMETER.VALIDATE
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.H.PROVISION.PARAMETER.VALIDATE is a validation routine attached to the TEMPLATE
*                    - REDO.H.PROVISION.PARAMETER, the routine checks if the value entered in the
*                    COB.FREQUENCY is a valid frequency or not
*Linked With       : Template - REDO.H.PROVISION.PARAMETER
*In  Parameter     : NA
*Out Parameter     : NA
*Files  Used       : REDO.H.PROVISION.PARAMETER           As              I               Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                  Reference                  Description
*   ------            ------               -------------               -------------
* 23 Sep 2010        Mudassir V         ODR-2010-09-0167 B.23B        Initial Creation
* 22-Oct-2010        G.Bharath          ODR-2009-11-0159 B.23A        New Validations added
* 10-May-2011       Sudharsanan S       PACS00061656                  New Validations Added
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.H.PROVISION.PARAMETER
*-------------------------------------------------------------------------------------------------------
    GOSUB CHECK.DUP
RETURN
*--------------------------------------------------------------------------------------------------------
**********
CHECK.DUP:
**********
    AF = PROV.SEC.DR.CODE
    CALL DUP

    AF = PROV.SEC.CR.CODE
    CALL DUP

    AF = PROV.MM.PROD.CATEG
    CALL DUP

    AF = PROV.EXEMP.SECTOR
    CALL DUP

*-----------------------
* ODR-2009-11-0159 - S
*-----------------------

    AF = PROV.LOAN.TYPE
    CALL DUP

    AF = PROV.PRODUCT.GROUP
    CALL DUP

*-----------------------
* ODR-2009-11-0159 - E
*-----------------------
* PACS00061656 - S
*------------------------
    AF = PROV.RATING.TYPE
    CALL DUP
    Y.TOT.RAT= DCOUNT(R.NEW(PROV.RATING.TYPE),@VM)
    Y.COUNT     = 1

    LOOP
    WHILE Y.COUNT LE Y.TOT.RAT
        Y.PROV.RATING.TYPE=R.NEW(PROV.RATING.TYPE)<1,Y.COUNT>
        Y.CHECK=ISUPPER(Y.PROV.RATING.TYPE)
        IF Y.CHECK EQ 0 THEN
            ETEXT="EB-LOWER.CASE"
            CALL STORE.END.ERROR
        END
        Y.COUNT += 1
    REPEAT


    AF.LIST = PROV.RATING.PERCENTAGE
    CALL DUP.FLD.SET(AF.LIST)

*------------------------
* PACS00061656 -E
*------------------------

RETURN
*--------------------------------------------------------------------------------------------------------
END       ;* End of Program
