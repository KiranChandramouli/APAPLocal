$PACKAGE APAP.REDOENQ
SUBROUTINE E.APAP.INSURANCE.FINDFIELDS.BRTN (ENQ.DATA)
*
*
*=====================================================================
* Subroutine Type : BUILD ROUTINE
* Attached to     :
* Attached as     :
* Primary Purpose :
*---------------------------------------------------------------------
* Modification History:
*
* Development for : APAP
* Development by  : cherrera@temenos.com
* Date            : 2011-08-10
* 06-APRIL-2023      Conversion Tool       R22 Auto Conversion - No changes
* 06-APRIL-2023      Harsha                R22 Manual Conversion - No changes                             
*------------------------------------------------------------------------

*=====================================================================

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON

*
************************************************************************
*


    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB PROCESS

RETURN

****************************************
PROCESS:


    Y.NAMEBEHA1 = R.NEW(4)<1,AV,AS>
    Y.NAMEBEHA2 = R.NEW(5)<1,AV,AS>


    LOCATE 'NAMEBEHA' IN ENQ.DATA<2,1> SETTING NAMEBEHA.POS THEN
        W.NAMEBEHA = ENQ.DATA<4,NAMEBEHA.POS>
    END

    LOCATE 'NAME' IN ENQ.DATA<2,1> SETTING NAME.POS THEN END

    LOCATE 'BEHA' IN ENQ.DATA<2,1> SETTING BEHA.POS THEN END

    W.NAME = W.NAMEBEHA["*",1,1]
    W.NAME = W.NAME["-1",1,1]
    W.BEHA = W.NAMEBEHA["*",2,1]

    ENQ.DATA<2,BEHA.POS> = 'BEHA'
    ENQ.DATA<3,BEHA.POS> = 'EQ'
    ENQ.DATA<4,BEHA.POS> = W.BEHA

    ENQ.DATA<2,NAME.POS> = 'NAME'
    ENQ.DATA<3,NAME.POS> = 'EQ'
    ENQ.DATA<4,NAME.POS> = W.NAME

RETURN

*********************************

OPEN.FILES:

RETURN

****************************

INITIALISE:

    SEL.CMD      = ''
    SEL.LIST     = ''
    NO.OF.REC    = 0
    Y.ERR        = ''
    Y.POS        = 0
    NAMEBEHA.POS = 0
    BEHA.POS     = 0
    NAME.POS     = 0
    W.NAME       = ''
    W.BEHA       = ''
    W.NAMEBEHA   = ''

RETURN

**********************

END
