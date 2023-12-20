$PACKAGE APAP.REDOENQ
SUBROUTINE E.INSURANCE.COMB.PARAM.FIELDS
*
*--------------------------------------------------------------------------------------------
* Company Name : APAP
* Developed By : CRISTHIAN HERRERA - RTAM
*--------------------------------------------------------------------------------------------
* Description: This routine is an INPUT routine for a version
*
* Linked With:
*
* In Parameter:
*               NONE
*
* Out Parameter:
*               NONE
*--------------------------------------------------------------------------------------------
* Modification Details:
*=====================
* 10/08/2011 - ODR-2011-03-0154
*              Description of the development associated
*              cherrera@temenos.com
*
* 27/10/2011 - ODR-2011-03-0154
*              Include I_B02.COMMON, variables COMM.AV, COMM.AS
*              ejijon@temenos.com
*  DATE             WHO                   REFERENCE 
* 06-APRIL-2023      Conversion Tool       R22 Auto Conversion  - I to I.VAR
* 06-APRIL-2023      Harsha                R22 Manual Conversion - No changes
*--------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.APAP.H.INSURANCE.COMB.PARAM
    $INSERT I_F.APAP.H.INSURANCE.CLASS.POLICY
    $INSERT I_F.APAP.H.INSURANCE.POLICY.TYPE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_B02.COMMON

*---------------------------------------------------------------------------------------------
    GOSUB INITIALISE
    GOSUB GET.FIELD.POSSITION
    GOSUB PROCESS

*--------------------------------------------------------------------------
*
RETURN
*
*--------------------------------------------------------------------------

INITIALISE:
    PROCESS.GOAHEAD                = 1
    APP.NAME                       = APPLICATION
    NAME.POS                       = 'FIELD.NAME'
    BEHA.POS                       = 'FIELD.BEHA'
    NAMEBEHA.POS                   = 'NAME.BEHAVIOUR'
    W.FIELD.NAME                   = ''
    W.FIELD.BEHA                   = ''
    W.NAME.BEHA                    = ''
    Y.APP.ERR                      = ''
    W.FIELD                        = ''
    I.VAR                              = 0
RETURN

*--------------------------------------------------------------------------
GET.FIELD.POSSITION:
    CALL EB.GET.APPL.FIELD(APP.NAME,NAME.POS,'',Y.APP.ERR)
    CALL EB.GET.APPL.FIELD(APP.NAME,BEHA.POS,'',Y.APP.ERR)
    CALL EB.GET.APPL.FIELD(APP.NAME,NAMEBEHA.POS,'',Y.APP.ERR)

RETURN

*--------------------------------------------------------------------------
PROCESS:

    COMM.AV                      = AV
    COMM.AS                      = AS
    R.NEW(NAMEBEHA.POS)<1,AV,AS> = W.NAME.BEHA
    W.FIELD.NAME                 = R.NEW(NAME.POS)<1,AV>
    W.FIELD.BEHA                 = COMI
    W.NAME.BEHA                  = W.FIELD.NAME:'*':W.FIELD.BEHA
    R.NEW(NAMEBEHA.POS)<1,AV,AS> = W.NAME.BEHA
    W.NAME.BEHA                  = ''

RETURN
END
