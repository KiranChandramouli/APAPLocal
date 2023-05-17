*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE AI.REDO.KILL.OTH.SESSION
*-----------------------------------------------------------------------------
*Company   Name    : APAP
*Developed By      : Martin Macias
*Program   Name    : AI.REDO.KILL.OTH.SESSION
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_EQUATE
    $INSERT I_System

    FN.TOKEN = 'F.OS.TOKEN'
    F.TOKEN = ''
    CALL OPF(FN.TOKEN,F.TOKEN)

    Y.USR.VAR = System.getVariable("CURRENT.EXT.USER.ID")
    SEL.CMD = "SELECT ":FN.TOKEN:" WITH EXTERNAL.USER EQ ":Y.USR.VAR
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,Y.ERR)

    IF NO.OF.REC NE 0 THEN
*    DELETE F.TOKEN,SEL.LIST<1> ;*Tus Start
        CALL F.DELETE(FN.TOKEN,SEL.LIST<1>) ;*Tus End
    END

    RETURN
END
