* Subroutine type : Subroutine
* Attached to     : Enquiry AI.MESSAGE.READ.IN
* Attached as     : BUILD Routine
* Incoming        : ENQ.DATA Common varible
* outgoing        : ENQ.DATA
* Purpose         : To change the Message status to "READ"
*                 :
*                 : to the common variable O.DATA
* @author         : madhusudananp@temenos.com
* Change History  :
* Version         : First version

*================================================================================================
SUBROUTINE REDO.E.CHK.MSG.READ

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.EB.SECURE.MESSAGE
    $INSERT I_System

*    MSG.ID = ENQ.DATA<4,1>

    MSG.ID = System.getVariable("CURRENT.MSG.ID")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN
        MSG.ID = ""
    END
    FnEsm = 'F.EB.SECURE.MESSAGE'
    FEsm = ''

    OPEN FnEsm TO F.ESM THEN



*    READ RecEsm FROM F.ESM,MSG.ID THEN ;*Tus Start
        CALL F.READ(FnEsm,MSG.ID,RecEsm,F.ESM,RecEsm.ERR)
        IF RecEsm THEN  ;* Tus End
            RecEsm<EB.SM.TO.STATUS> = "READ"

*      WRITE RecEsm TO F.ESM,MSG.ID ;*Tus Start
            CALL F.WRITE(FnEsm,MSG.ID,RecEsm);* Tus End
        END
    END
RETURN
