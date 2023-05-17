*-----------------------------------------------------------------------------
* <Rating>-22</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE MB.SDB.MAINT
*------------------------------------------------------------------------------------
!** Properties AND Methods FOR TEMPLATE
* TODO add a description of the application here.
* @author kbrindha@temenos.com
* @stereotype Application
* @uses C_METHODS
* @uses C_PROPERTIES
* @package infra.eb
*!
*-----------------------------------------------------------------------------
* Revision History:
*------------------
* Date               who           Reference            Description
* 5/02/2009      K.BRINDHA                        Initial Version.
*-----------------------------------------------------------------------------
* TODO - Replace XX with product code
* TODO - Replace TABLE with the application name
* TODO - You MUST write a .FIELDS routine for the field definitions
* TODO - For type W applications, you MUST write a .RUN routine
* TODO - Flag the methods that you need to use with a 'Y'
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_METHODS.AND.PROPERTIES
*-----------------------------------------------------------------------------
    C_METHODS = ''
    C_PROPERTIES = ''
*-----------------------------------------------------------------------------
    C_PROPERTIES<P_NAME> = 'MB.SDB.MAINT'         ;* Full application name including product prefix
    C_PROPERTIES<P_TITLE> = 'MB.SDB.MAINT'        ;* Screen title
    C_PROPERTIES<P_STEREOTYPE> = 'H'    ;* H, U, L, W or T
    C_PROPERTIES<P_PRODUCT> = 'EB'      ;* Must be on EB.PRODUCT
    C_PROPERTIES<P_SUB.PRODUCT> = ''    ;* Must be on EB.SUB.PRODUCT
    C_PROPERTIES<P_CLASSIFICATION> = 'INT'        ;* As per FILE.CONTROL
    C_PROPERTIES<P_SYS.CLEAR.FILE> = '' ;* As per FILE.CONTROL
    C_PROPERTIES<P_RELATED.FILES> = ''  ;* As per FILE.CONTROL
    C_PROPERTIES<P_PC.FILE> = ''        ;* As per FILE.CONTROL
    C_PROPERTIES<P_EQUATE.PREFIX> = 'SDB.MNT'     ;* Use to create I_F.XX.TABLE
*-----------------------------------------------------------------------------
    C_PROPERTIES<P_ID.PREFIX> = ''      ;* Used by EB.FORMAT.ID if set
    C_PROPERTIES<P_BLOCKED.FUNCTIONS> = ''        ;* Space delimeted list of blocked functions
    C_PROPERTIES<P_TRIGGER> = ''        ;* Trigger field used for OPERATION style fields
*-----------------------------------------------------------------------------
    C_METHODS<M_INITIALISE> = ''        ;* Use this to load a common area
    C_METHODS<M_ID> = ''      ;* Check ID
    C_METHODS<M_RECORD> = 'Y' ;* Check Record
    C_METHODS<M_VALIDATE> = 'Y'         ;* Cross validation
    C_METHODS<M_OVERRIDES> = ''         ;* Overrides
    C_METHODS<M_FUNCTION> = ''          ;* Check Function
    C_METHODS<M_PREVIEW> = '' ;* Delivery Preview
    C_METHODS<M_PROCESS> = '' ;* The main processing routine
    C_METHODS<M_AUTHORISE> = ''         ;* Any work that needs to be done at authorisation
    C_METHODS<M_DEFAULT> = '' ;* Any defaulting
*-----------------------------------------------------------------------------
    CALL THE.TEMPLATE
    RETURN
END

