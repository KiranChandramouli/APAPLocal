* @ValidationCode : MjotMTM1MDEyNjIxMDpDcDEyNTI6MTY4MjQxMjMzNjY1MzpIYXJpc2h2aWtyYW1DOi0xOi0xOjA6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:36
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.AUT.TT.CASH.PAY
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: H GANESH
* PROGRAM NAME: REDO.V.AUT.TT.CASH.PAY
* ODR NO : ODR-2009-10-0838
*----------------------------------------------------------------------
*DESCRIPTION: This is AUTHORISATION routine for the VERSION TELLER,LCY.CASHIN.LETTER.PAY
* to launch an enquiry based on type of letter for PDF generation


*IN PARAMETER: NA
*OUT PARAMETER: NA
*LINKED WITH: REDO.LETTER.ISSUE
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE WHO REFERENCE DESCRIPTION
*18.03.2010 H GANESH ODR-2009-10-0838 INITIAL CREATION
*----------------------------------------------------------------------
*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*10-04-2023            Conversion Tool             R22 Auto Code conversion                      CONVERT TO CHANGE, TNO TO C$T24.SESSION.NO
*10-04-2023              Samaran T                R22 Manual Code conversion                         No Changes
*----------------------------------------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.LETTER.ISSUE
    $INSERT I_F.DEAL.SLIP.FORMAT
    $INSERT I_F.USER
    $INSERT I_GTS.COMMON
    $INSERT I_F.TELLER

    GOSUB INIT
    GOSUB OPENFILES
    GOSUB LOCAL.REF
    GOSUB PROCESS
RETURN

*----------------------------------------------------------------------
INIT:
*----------------------------------------------------------------------

    FN.REDO.LETTER.ISSUE='F.REDO.LETTER.ISSUE$NAU'
    F.REDO.LETTER.ISSUE=''
    FN.REDO.LETTER.ISSUE.LIVE='F.REDO.LETTER.ISSUE'
    F.REDO.LETTER.ISSUE.LIVE=''
RETURN

*----------------------------------------------------------------------
OPENFILES:
*----------------------------------------------------------------------
    CALL OPF(FN.REDO.LETTER.ISSUE,F.REDO.LETTER.ISSUE)
    CALL OPF(FN.REDO.LETTER.ISSUE.LIVE,F.REDO.LETTER.ISSUE.LIVE)
RETURN
*----------------------------------------------------------------------
LOCAL.REF:
*----------------------------------------------------------------------

    LOC.REF.APPLICATION="TELLER"
    LOC.REF.FIELDS='L.LETTER.ID'
    LOC.REF.POS=''
    CALL GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)

    POS.L.LETTER.ID=LOC.REF.POS<1,1>
RETURN

*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------

    Y.LETTER.ISSUE.ID=R.NEW(TT.TE.LOCAL.REF)<1,POS.L.LETTER.ID>
    CALL F.READ(FN.REDO.LETTER.ISSUE,Y.LETTER.ISSUE.ID,R.REDO.LETTER.ISSUE,F.REDO.LETTER.ISSUE,LETTER.ERR)
    Y.LETTER.TYPE=R.REDO.LETTER.ISSUE<REDO.LET.ISS.TYPE.OF.LETTER>
    TEMPTIME = OCONV(TIME(),"MTS")
    TEMPTIME = TEMPTIME[1,5]
    CHANGE ':' TO '' IN TEMPTIME  ;*R22 AUTO CODE CONVERSION
    CHECK.DATE = DATE()
    R.REDO.LETTER.ISSUE<REDO.LET.ISS.WAIVE.CHARGES>='YES'
    R.REDO.LETTER.ISSUE<REDO.LET.ISS.RECORD.STATUS>=''
    R.REDO.LETTER.ISSUE<REDO.LET.ISS.DATE.TIME>=OCONV(CHECK.DATE,"DY2"):FMT(OCONV(CHECK.DATE,"DM"),"R%2"):OCONV(CHECK.DATE,"DD"):TEMPTIME
    R.REDO.LETTER.ISSUE<REDO.LET.ISS.CURR.NO>='2'
    R.REDO.LETTER.ISSUE<REDO.LET.ISS.AUTHORISER>=C$T24.SESSION.NO:'_':OPERATOR     ;*R22 AUTO CODE CONVERSION
    R.REDO.LETTER.ISSUE<REDO.LET.ISS.DEPT.CODE>=R.USER<EB.USE.DEPARTMENT.CODE>
    R.REDO.LETTER.ISSUE<REDO.LET.ISS.CO.CODE>=ID.COMPANY
    GOSUB UPDATE.LETTER

    BEGIN CASE

        CASE Y.LETTER.TYPE EQ 'AUDITOR'

            NEW.TASK="ENQ REDO.AUDITOR.PDF.GEN Y.ARRAY"
            CALL EB.SET.NEW.TASK(NEW.TASK)

        CASE Y.LETTER.TYPE EQ 'BALANCE'

            NEW.TASK="ENQ REDO.BALANCE.CERTF.PDF.GEN Y.ARRAY"
            CALL EB.SET.NEW.TASK(NEW.TASK)

        CASE Y.LETTER.TYPE EQ 'COMMERCIAL'

            NEW.TASK="ENQ REDO.COMMERCIAL.REF.PDF.GEN Y.ARRAY"
            CALL EB.SET.NEW.TASK(NEW.TASK)

        CASE Y.LETTER.TYPE EQ 'CONSULAR'

            NEW.TASK="ENQ REDO.CONSULAR.PDF.GEN Y.ARRAY"
            CALL EB.SET.NEW.TASK(NEW.TASK)

        CASE Y.LETTER.TYPE EQ 'INDIVIDUAL'

            NEW.TASK="ENQ REDO.INDIVIDUAL.REF.PDF.GEN Y.ARRAY"
            CALL EB.SET.NEW.TASK(NEW.TASK)

        CASE Y.LETTER.TYPE EQ 'INTERNAL'

            NEW.TASK="ENQ REDO.INTERNAL.TAX.PDF.GEN Y.ARRAY"
            CALL EB.SET.NEW.TASK(NEW.TASK)

    END CASE
RETURN

*----------------------------------------------------------------------
UPDATE.LETTER:
*----------------------------------------------------------------------
* This GOSUB updates the REDO.LETTER.ISSUE template and sets the fieild WAIVE.CHARGES to YES

    CALL F.WRITE(FN.REDO.LETTER.ISSUE.LIVE,Y.LETTER.ISSUE.ID,R.REDO.LETTER.ISSUE)
    CALL F.DELETE(FN.REDO.LETTER.ISSUE,Y.LETTER.ISSUE.ID)
RETURN

END
