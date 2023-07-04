* @ValidationCode : Mjo0NDE1ODM1MTpDcDEyNTI6MTY4MTE1MTYyMDY1NjpJVFNTOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 11 Apr 2023 00:03:40
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.VAU.MTS.SUSPENT1
*
*--------------------------------------------------------------------------------------------
* Company Name : Bank Name
* Developed By : Temenos Application Management
*--------------------------------------------------------------------------------------------
* Description:
*
*--------------------------------------------------------------------------------------------
* Modification Details:
*=====================
* 23/07/2009 - ODR-2009- XX-XXXX
*              Description of the development associated.
*
*
* Date             Who                   Reference      Description
* 11.04.2023       Conversion Tool       R22            Auto Conversion     - FM TO @FM, VM TO @VM, New condition added
* 11.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*
*--------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_System
*
    $INSERT I_F.TELLER.ID
    $INSERT I_F.TELLER
*
    $INSERT I_F.REDO.TRANSACTION.CHAIN
*
*--------------------------------------------------------------------------------------------
*
    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END
    IF Y.TEXT.MSG THEN
        ETEXT           = Y.TEXT.MSG
        AF = TT.TE.AMOUNT.LOCAL.1
        CALL STORE.END.ERROR
        ETEXT           = ""
    END
*
RETURN
*
*--------------------------------------------------------------------------------------------
PROCESS:
*--------------------------------------------------------------------------------------------
*
    IF Y.PROC EQ "S" AND Y.DR.CR EQ "CREDIT" THEN
        Y.MONTO = Y.MONTO * -1
    END

    CALL F.READU(FN.TELLER.ID,Y.TID,R.TELLER.ID,F.TELLER.ID,ERR.MSJ,RTR)

    LOCATE Y.CCY IN CCY.AMOUNT<1> SETTING YPOS THEN
        IF Y.TYPE EQ "E" THEN
            CASH.AMOUT<YPOS>  = CASH.AMOUT<YPOS> + Y.MONTO
            R.TELLER.ID<TT.TID.LOCAL.REF,WCASH> =   LOWER(LOWER(CASH.AMOUT))
        END

        IF Y.TYPE EQ "C" THEN
            CHECK.AMOUNT<YPOS>  = CHECK.AMOUNT<YPOS> + Y.MONTO
            R.TELLER.ID<TT.TID.LOCAL.REF,WCHECK> = LOWER(LOWER(CHECK.AMOUNT))
        END

    END

    CHECK.AMOUNT = RAISE(RAISE(R.TELLER.ID<TT.TID.LOCAL.REF,WCHECK>))
    CASH.AMOUT   = RAISE(RAISE(R.TELLER.ID<TT.TID.LOCAL.REF,WCASH>))
    WW.CASH      = SUM(CASH.AMOUT)
    WW.CHECK     = SUM(CHECK.AMOUNT)
    WSTATUS      = "SP"
    IF WW.CASH EQ 0 AND WW.CHECK EQ 0 THEN

        R.TELLER.ID<TT.TID.LOCAL.REF,WPOSLI>= ""
        R.TELLER.ID<TT.TID.LOCAL.REF,WCCY>   = ""
        R.TELLER.ID<TT.TID.LOCAL.REF,WCHECK> = ""
        R.TELLER.ID<TT.TID.LOCAL.REF,WCASH>  = ""
        WSTATUS = "S"
    END

    CALL F.WRITE(FN.TELLER.ID,Y.TID,R.TELLER.ID)

    GOSUB UPDATE.TXN.CHAIN
*
RETURN
*
*--------------------------------------------------------------------------------------------
UPDATE.TXN.CHAIN:
*--------------------------------------------------------------------------------------------
*
    CALL F.READU(FN.REDO.TRANSACTION.CHAIN,Y.IID,R.REDO.TRANSACTION.CHAIN,F.REDO.TRANSACTION.CHAIN,ERR.MSJ,RTR)

    R.REDO.TRANSACTION.CHAIN<RTC.TRANS.AUTH>   = WSTATUS

    CALL F.WRITE(FN.REDO.TRANSACTION.CHAIN,Y.IID,R.REDO.TRANSACTION.CHAIN)
*
RETURN
*
*--------------------------------------------------------------------------------------------
OPEN.FILES:
*--------------------------------------------------------------------------------------------
*
    CALL OPF(FN.REDO.TRANSACTION.CHAIN,F.REDO.TRANSACTION.CHAIN)
*
RETURN
*
*--------------------------------------------------------------------------------------------
INITIALISE:
*--------------------------------------------------------------------------------------------
*
    LOOP.CNT         = 1
    MAX.LOOPS        = 1
    PROCESS.GOAHEAD  = 1
    Y.TEXT.MSG       = ""

    Y.MONTO  = System.getVariable("CURRENT.MONTO")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN                   ;** R22 Auto Conversion - Start
        Y.MONTO = ""
    END                                             ;** R22 Auto Conversion - End
    Y.CCY    = System.getVariable("CURRENT.CCY")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN          ;** R22 Auto Conversion - Start
        Y.CCY = ""
    END                                         ;** R22 Auto Conversion - End
    Y.TID    = System.getVariable("CURRENT.TID")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN             ;** R22 Auto Conversion - Start
        Y.TID = ""
    END                                            ;** R22 Auto Conversion - End
    Y.IID    = System.getVariable("CURRENT.IID")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN                 ;** R22 Auto Conversion - Start
        Y.IID = ""
    END                                               ;** R22 Auto Conversion - End
    Y.TYPE   = System.getVariable("CURRENT.TYPE")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN                       ;** R22 Auto Conversion - Start
        Y.TYPE = ""
    END                                                         ;** R22 Auto Conversion - End
    Y.PROC   = System.getVariable("CURRENT.PROC")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN                   ;** R22 Auto Conversion - Start
        Y.PROC = ""
    END                                                   ;** R22 Auto Conversion - End

    CHANGE "," TO "" IN Y.MONTO

    Y.DR.CR = R.NEW(TT.TE.DR.CR.MARKER)

    FN.TELLER.ID = "F.TELLER.ID"
    F.TELLER.ID  = ""

    FN.REDO.TRANSACTION.CHAIN = "F.REDO.TRANSACTION.CHAIN"
    F.REDO.TRANSACTION.CHAIN  = ""

    WCAMPO    = "L.INITIAL.ID"
    WCAMPO<2> = "L.CH.CASH"
    WCAMPO<3> = "L.CH.CHECK"
    WCAMPO<4> = "L.CH.CCY"
    WCAMPO    = CHANGE(WCAMPO,@FM,@VM)
    YPOS = ''
    CALL MULTI.GET.LOC.REF("TELLER.ID",WCAMPO,YPOS)
    WPOSLI  = YPOS<1,1>
    WCASH   = YPOS<1,2>
    WCHECK  = YPOS<1,3>
    WCCY    = YPOS<1,4>
*
RETURN
*--------------------------------------------------------------------------------------------
CHECK.PRELIM.CONDITIONS:
*--------------------------------------------------------------------------------------------
*
    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
        BEGIN CASE

            CASE LOOP.CNT EQ 1

                CALL F.READ(FN.TELLER.ID,Y.TID,R.TELLER.ID,F.TELLER.ID,ERR.MSJ)
                IF R.TELLER.ID THEN

                    CCY.AMOUNT   = RAISE(RAISE(R.TELLER.ID<TT.TID.LOCAL.REF,WCCY>))
                    CHECK.AMOUNT = RAISE(RAISE(R.TELLER.ID<TT.TID.LOCAL.REF,WCHECK>))
                    CASH.AMOUT   = RAISE(RAISE(R.TELLER.ID<TT.TID.LOCAL.REF,WCASH>))

                END ELSE
                    Y.TEXT.MSG      = "EB-TELLER.&.DOES.NOT.EXIST"
                    PROCESS.GOAHEAD = 0
                END
        END CASE

        LOOP.CNT +=1
    REPEAT
*
RETURN
*--------------------------------------------------------------------------------------------

END
