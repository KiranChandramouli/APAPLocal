* @ValidationCode : MjotMzc2MzIzNzMzOkNwMTI1MjoxNjg0MjMzNTM0NDc4OklUU1M6LTE6LTE6Nzk3OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 16 May 2023 16:08:54
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 797
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*========================================================================
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
SUBROUTINE LAPAP.VERIFY.AZ.STATUS2
*========================================================================
* Technical report:
* =================
* Company Name   : APAP
* Program Name   : LAPAP.VERIFY.AZ.STATUS2
* Date           : 2018-05-21
* Item ID        : CN004475
*========================================================================
* Brief description :
* -------------------
* This program verify in 360 view whether exists or not a second status
* field filled in customer table, replacing in the ENQ first value.
*========================================================================
* Modification History :
* ======================
* Date           Author            Modification Description
* -------------  -----------       ---------------------------
* 2018-05-21     Richard HC                Initial Development
*========================================================================
* Content summary :
* =================
* Table name     : CUSTOMER
* Auto Increment : N/A
* Views/versions : 360 VIEW
* EB record      : LAPAP.VERIFY.AZ.STATUS2
* Routine        : LAPAP.VERIFY.AZ.STATUS2
*========================================================================
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*24-04-2023       Conversion Tool        R22 Auto Code conversion          INSERT FILE MODIFIED,B TO B.VAR, M TO M.VAR,# TO NE
*24-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*-----------------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON    ;*R22 AUTO CODE CONVERSION.START
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.EB.LOOKUP
    $INSERT I_ENQUIRY.COMMON    ;*R22 AUTO CODE CONVERSION.END
   $USING EB.LocalReferences

    ACC = O.DATA

    FN.EBL = "F.EB.LOOKUP"
    FN.ACC = "F.ACCOUNT"
    F.ACC = ""
    F.EBL = ""

    CALL OPF(FN.EBL,F.EBL)
    CALL OPF(FN.ACC,F.ACC)
    CALL F.READ(FN.ACC,ACC,R.ACC,F.ACC,E.ACC)

*    CALL GET.LOC.REF("ACCOUNT","L.AC.STATUS1",POS1)
EB.LocalReferences.GetLocRef("ACCOUNT","L.AC.STATUS1",POS1);* R22 UTILITY AUTO CONVERSION
*    CALL GET.LOC.REF("ACCOUNT","L.AC.STATUS2",POS2)
EB.LocalReferences.GetLocRef("ACCOUNT","L.AC.STATUS2",POS2);* R22 UTILITY AUTO CONVERSION
    FLD1 = R.ACC<AC.LOCAL.REF,POS1>
    FLD2 = R.ACC<AC.LOCAL.REF,POS2>

    APAP.LAPAP.lapapVerifyCategory(ACC,CTG);* R22 Manual conversion
    IF CTG EQ 2 THEN

        IF FLD2 NE "" THEN        ;*R22 AUTO CODE CONVERSION

            M.VAR = DCOUNT(FLD2,@SM)
            FOR A = 1 TO M.VAR STEP 1

                MM =  R.ACC<AC.LOCAL.REF,POS2,1>
                UU = R.ACC<AC.LOCAL.REF,POS2,2>
                PP = R.ACC<AC.LOCAL.REF,POS2,3>

                EBL = "L.AC.STATUS2*":MM
                OBL = "L.AC.STATUS2*":UU
                HC = "L.AC.STATUS2*":PP

                CALL F.READ(FN.EBL,EBL,R.EBL,F.EBL,E.EBL)
                EBLOOKUP = R.EBL<EB.LU.DESCRIPTION>
                CALL F.READ(FN.EBL,OBL,R.EBL,F.EBL,E.EBL)
                EBLOOKUP3 = R.EBL<EB.LU.DESCRIPTION>
                CALL F.READ(FN.EBL,HC,R.EBL,F.EBL,E.EBL)
                EBLOOKUP2 = R.EBL<EB.LU.DESCRIPTION>

            NEXT A

            IF M.VAR NE 1 THEN      ;*R22 AUTO CODE CONVERSION
                O.DATA = EBLOOKUP<1,2>:@VM:EBLOOKUP3<1,2>:@VM:EBLOOKUP2<1,2>
            END ELSE
                O.DATA=EBLOOKUP<1,2>
            END
            RETURN

        END


        ELSE

            PP = DCOUNT(FLD1,@SM)
            FOR B.VAR = 1 TO PP STEP 1

                II = R.ACC<AC.LOCAL.REF,POS1,B.VAR>
                UBL="L.AC.STATUS1*":II
                CALL F.READ(FN.EBL,UBL,R.EBL,F.EBL,E.EBL)
                EBLOOK = R.EBL<EB.LU.DESCRIPTION>

            NEXT B.VAR
            O.DATA = EBLOOK<1,2>
            RETURN

        END

    END ELSE

        PP = DCOUNT(FLD1,@SM)
        FOR B.VAR = 1 TO PP STEP 1

            II = R.ACC<AC.LOCAL.REF,POS1,B.VAR>
            UBL="L.AC.STATUS1*":II
            CALL F.READ(FN.EBL,UBL,R.EBL,F.EBL,E.EBL)
            EBLOOK = R.EBL<EB.LU.DESCRIPTION>

        NEXT B.VAR
        O.DATA = EBLOOK<1,2>
        RETURN

    END


END
