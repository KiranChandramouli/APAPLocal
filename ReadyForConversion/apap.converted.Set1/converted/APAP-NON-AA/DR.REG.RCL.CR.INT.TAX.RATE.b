SUBROUTINE DR.REG.RCL.CR.INT.TAX.RATE
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DR.REG.INT.TAX.PAYMENT.COMMON
    $INSERT I_DR.REG.INT.TAX.COMMON

    CR.INT.RATE = COMI
    IF CR.INT.RATE THEN
        CHANGE @VM TO @FM IN CR.INT.RATE
        CNT.INT.RATE = DCOUNT(CR.INT.RATE,@FM)
        COMI = CR.INT.RATE<CNT.INT.RATE>
    END ELSE
        COMI = ''
    END
RETURN
END
