SUBROUTINE REDO.E.GET.CCARD.BAL(Y.FINAL.ARRAY)
*---------------------------------------------------------------------------------
* This is aenquiry for list the details of credit card
*this enquiry will fetch the data from sunnel interface
*---------------------------------------------------------------------------------
* Company Name   : APAP
* Developed By   : Prabhu N
* Program Name   : REDO.E.GET.CCARD.DETAILS
* ODR NUMBER     : SUNNEL-CR
* LINKED WITH    : ENQUIRY-REDO.CCARD.DETAILS
*---------------------------------------------------------------------------------
*IN = N/A
*OUT = Y.FINAL.ARRAY
*---------------------------------------------------------------------------------
*MODIFICATION:
*---------------------------------------------------------------------------------
*DATE           ODR                   DEVELOPER               VERSION
*--------       ----------------      -------------           --------------------
*3.12.2010     ODR-2010-11-0211      Prabhu N                Initial creation
*---------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_System
    GOSUB INITIALISE
    GOSUB PROCESS
RETURN
*---------------------------------------------------------------------------------
INITIALISE:
*---------------------------------------------------------------------------------

    FN.REDO.EB.USER.PRINT.VAR='F.REDO.EB.USER.PRINT.VAR'
    F.REDO.EB.USER.PRINT.VAR=''
    CALL OPF(FN.REDO.EB.USER.PRINT.VAR,F.REDO.EB.USER.PRINT.VAR)

    Y.USR.VAR = System.getVariable("EXT.EXTERNAL.USER")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN
        Y.USR.VAR = ""
    END
    Y.USR.VAR = Y.USR.VAR:"-":"CURRENT.CARD.CORTE"


*  READ HTML.DATA FROM F.REDO.EB.USER.PRINT.VAR,Y.USR.VAR ELSE ;*Tus Start
    CALL F.READ(FN.REDO.EB.USER.PRINT.VAR,Y.USR.VAR,HTML.DATA,F.REDO.EB.USER.PRINT.VAR,HTML.DATA.ERR)
    IF HTML.DATA.ERR THEN  ;* Tus End
        HTML.DATA = ''
    END

    Y.ARRAY='BE_K_TC.BE_P_RESCUENTATC_A'
    CALL REDO.V.WRAP.SUNNEL(Y.ARRAY)
*---------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------

    IF Y.ARRAY<28> NE '0' THEN
        ENQ.ERROR='EB-SUNNEL.VAL.FAIL'
        RETURN
    END

    IF Y.ARRAY<16> EQ 'null' THEN
        Y.ARRAY<16> = ''
    END
    Y.FINAL.ARRAY=Y.ARRAY<5>:'*':Y.ARRAY<6>:'*':Y.ARRAY<20>:'*':Y.ARRAY<9>:'*':Y.ARRAY<10>:'*':Y.ARRAY<11>:'*':Y.ARRAY<18>:'*':Y.ARRAY<19>:'*':Y.ARRAY<16>:'*':Y.ARRAY<17>:'*':Y.ARRAY<23>:'*':Y.ARRAY<24>:'*':Y.ARRAY<25>:'*':Y.ARRAY<26>:'*':Y.ARRAY<7>:'*':Y.ARRAY<8>:'*':Y.ARRAY<14>:'*':Y.ARRAY<15>:'*':Y.ARRAY<21>:'*':Y.ARRAY<22>
*    CALL System.setVariable("CURRENT.CACC.NO",Y.ARRAY<2>)
*    CALL System.setVariable("CURRENT.CORTE.DT",Y.ARRAY<20>)
    HTML.DATA <1,1>=Y.ARRAY<2>
    HTML.DATA <1,2>=Y.ARRAY<20>

*  WRITE HTML.DATA TO F.REDO.EB.USER.PRINT.VAR,Y.USR.VAR ;*Tus Start
    CALL F.WRITE(FN.REDO.EB.USER.PRINT.VAR,Y.USR.VAR,HTML.DATA);*Tus End
RETURN
END
*------------------------------*END OF SUBROUTINE*--------------------------------
