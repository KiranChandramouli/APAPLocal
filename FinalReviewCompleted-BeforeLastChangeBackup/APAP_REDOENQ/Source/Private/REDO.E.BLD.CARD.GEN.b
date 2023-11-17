$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.BLD.CARD.GEN(ENQ.DATA)
*------------------------------------------------------------------------------------------------------
*DESCRIPTION
* returns the list of IDs that is created to fetch stock register ID

*------------------------------------------------------------------------------------------------------
*APPLICATION
* build routine to be attached in the enquiry REDO.CARD.STOCK.REGISTER
*----------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : Temenos Application Management
* PROGRAM NAME : REDO.E.BLD.CARD.GEN
*----------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO               REFERENCE         DESCRIPTION
*08.03.2011      Swaminathan     ODR-2010-03-0400   INITIAL CREATION
* 10-APRIL-2023      Conversion Tool       R22 Auto Conversion - VM to @VM
* 10-APRIL-2023      Harsha                R22 Manual Conversion - No changes
* ----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.COMPANY
    $INSERT I_F.REDO.CARD.SERIES.PARAM
    $INSERT I_F.REDO.CARD.REQUEST
    $INSERT I_F.REDO.CARD.GENERATION


    GOSUB PROCESS
RETURN

*------------------------------------------------------------
PROCESS:
*------------------------------------------------------------
    FN.REDO.CARD.GENERATION = 'F.REDO.CARD.GENERATION'
    F.REDO.CARD.GENERATION = ''
    CALL OPF(FN.REDO.CARD.GENERATION,F.REDO.CARD.GENERATION)

    FN.REDO.CARD.REQUEST = 'F.REDO.CARD.REQUEST'
    F.REDO.CARD.REQUEST = ''
    CALL OPF(FN.REDO.CARD.REQUEST,F.REDO.CARD.REQUEST)

    SEL.CMD =" SELECT ":FN.REDO.CARD.REQUEST:" WITH PRINTING.SE.ID NE '' "
    CALL EB.READLIST(SEL.CMD,SEL.CMD.LIST,NO.OF.REC,'',Y.ERR)
    Y.ARRAY  = ''
    LOOP
        REMOVE Y.ID FROM SEL.CMD.LIST SETTING POS
    WHILE  Y.ID:POS
        Y.CARD.GEN.RECORD = ''
        CALL F.READ(FN.REDO.CARD.GENERATION,Y.ID,R.REDO.CARD.GENERATION,F.REDO.CARD.GENERATION,Y.ERR.GEN)
        Y.CARD.GEN.RECORD = R.REDO.CARD.GENERATION<REDO.CARD.GEN.CARD.NUMBERS>
        IF Y.CARD.GEN.RECORD ELSE
            IF Y.ARRAY EQ '' THEN
                Y.ARRAY = Y.ID
            END ELSE
                Y.ARRAY<1,-1> = Y.ID
            END
        END
    REPEAT

    CHANGE @VM TO ' ' IN Y.ARRAY
    ENQ.DATA<2,1> = "@ID"
    ENQ.DATA<3,1> = "EQ"
    ENQ.DATA<4,1> = Y.ARRAY

RETURN
*------------------------------------------------------------
END
