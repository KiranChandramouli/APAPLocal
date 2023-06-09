SUBROUTINE REDO.UPDATE.OVERDUE.LOAN.STATUS
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :Temenos Application Management
*Program   Name    :REDO.TRIGGER.RESUME.ACTIVITY
*---------------------------------------------------------------------------------
*
*DESCRIPTION       :This program is used to update the local CONCAT file
*                   REDO.AA.OVERDUE.LOAN.STATUS with the arrangement ID which is to be processed in COB
*
*LINKED WITH       :Attached to ACTIVITY.API, for the activity LENDING-NEW-ARRANGEMENT and triggered during OVERDUE
*                   Update Action
*
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 31 AUG 2010    Ravikiran AV                  B.51          Initial Creation
*
*
*--------------------------------------------------------------------------------------------------------
* All File INSERTS done here
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_AA.LOCAL.COMMON
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT I_F.AA.ARRANGEMENT

*--------------------------------------------------------------------------------------------------------------------
*Main Logic of the routine
*
MAIN.LOGIC:

    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB CHECK.OVERDUE.LINK

RETURN
*------------------------------------------------------------------------------------------------------------------
* Initialise the required variables
*
INITIALISE:

    PROPERTY.CLASS = 'OVERDUE'

    PRODUCT.ID = c_aalocArrProductId
    ARR.CURRENCY = c_aalocArrCurrency
    EFFECTIVE.DATE = TODAY

    PROD.PROP.LIST = ''
    PROD.PROP.CLASS.LIST = ''
    PROD.PROP.LINK.TYPE = ''
    PROD.PROP.CONDITION.LIST = ''

    ARR.LINK = ''

    RET.ERR = ''

RETURN
*---------------------------------------------------------------------------------------------------------------------
* List of files to be opened
*
OPEN.FILES:

    FN.REDO.AA.OVERDUE.LOAN.STATUS = 'F.REDO.AA.OVERDUE.LOAN.STATUS'
    F.REDO.AA.OVERDUE.LOAN.STATUS = ''
    CALL OPF(FN.REDO.AA.OVERDUE.LOAN.STATUS, F.REDO.AA.OVERDUE.LOAN.STATUS)

RETURN
*-------------------------------------------------------------------------------------------------------------------
* Check The ARR.LINK for the OVERDUE property. If it is other than tracking, then update the Arrangement ID
* in the CONCAT file REDO.AA.OVERDUE.LOAN.STATUS
*
CHECK.OVERDUE.LINK:

    CALL AA.GET.PRODUCT.CONDITION.RECORDS(PRODUCT.ID, ARR.CURRENCY, EFFECTIVE.DATE, PROD.PROP.LIST, PROD.PROP.CLASS.LIST, PROD.PROP.LINK.TYPE, PROD.PROP.CONDITION.LIST, RET.ERR)

    LOCATE PROPERTY.CLASS IN PROD.PROP.CLASS.LIST SETTING OVERDUE.POS THEN        ;*Get the Overdue property position
        IF PROD.PROP.LINK.TYPE<OVERDUE.POS> NE 'TRACKING' THEN  ;*Check whether the Overdue Property is not set to tracking
            ARR.LINK = 1
        END
    END

    IF ARR.LINK THEN
        CONCAT.ID = c_aalocArrId
        F.OD.REC = ''
        CALL F.WRITE(FN.REDO.AA.OVERDUE.LOAN.STATUS, CONCAT.ID, F.OD.REC) ;* If Overdue is not tracking then Update the CONCAT file with the Arrangement ID
    END

RETURN
*-----------------------------------------------------------------------------------------------------------------------------
END
